# frozen_string_literal: true

require "test_helper"

class Futurism::HelperTest < ActionView::TestCase
  include Futurism::Helpers

  test "renders html options with data attributes" do
    post = Post.create title: "Lorem"

    element = Nokogiri::HTML.fragment(futurize(post, extends: :div, html_options: {class: "absolute inset-0", data: {controller: "test"}}) {})

    assert_equal "futurism-element", element.children.first.name
    assert_equal post, GlobalID::Locator.locate_signed(element.children.first["data-sgid"])
    assert_equal sign_params({data: {controller: "test"}}), element.children.first["data-signed-params"]
    assert_nil element.children.first["data-eager"]
    assert_equal "absolute inset-0", element.children.first["class"]

    params = {partial: "posts/card", locals: {post: post}}
    element = Nokogiri::HTML.fragment(futurize(**params.merge({html_options: {class: "flex justify-center", data: {action: "test#click"}}, extends: :div})) {})

    assert_equal "futurism-element", element.children.first.name
    assert_nil element.children.first["data-sgid"]
    assert_nil element.children.first["data-eager"]
    assert_equal "posts/card", extract_params(element.children.first["data-signed-params"])[:partial]
    assert_equal post.to_global_id.to_s, extract_params(element.children.first["data-signed-params"])[:locals][:post]
    assert_equal "test#click", extract_params(element.children.first["data-signed-params"])[:data][:action]
    assert_equal "flex justify-center", element.children.first["class"]
  end

  test "renders html options with data attributes with multi-word object" do
    action_item = ActionItem.create description: "Do this"

    element = Nokogiri::HTML.fragment(futurize(action_item, extends: :div) {})

    assert_equal "futurism-element", element.children.first.name
    assert_equal action_item, GlobalID::Locator.locate_signed(element.children.first["data-sgid"])
  end

  test "ensures signed_params and sgid are not overwritable" do
    post = Post.create title: "Lorem"

    element = Nokogiri::HTML.fragment(futurize(post, extends: :div, html_options: {data: {controller: "test", sgid: "test", signed_params: "test"}}) {})

    assert_equal post, GlobalID::Locator.locate_signed(element.children.first["data-sgid"])
    assert_equal sign_params({data: {controller: "test"}}), element.children.first["data-signed-params"]
  end

  test "allows to specify a new ActiveRecord record" do
    post = Post.new

    element = Nokogiri::HTML.fragment(futurize("posts/form", post: post, extends: :div) {})

    assert extract_params(element.children.first["data-signed-params"])[:locals][:post].new_record?
  end

  # PORO that is serializable/de-serializable
  class GlobalIdableEntity
    include GlobalID::Identification

    def id
      "fake-id"
    end

    def self.find(id)
      new if id == "fake-id"
    end
  end

  test "allows to specify any GlobalId-able entity" do
    entity = GlobalIdableEntity.new
    element = Nokogiri::HTML.fragment(futurize("posts/form", entity: entity, extends: :div) {})

    assert_equal "gid://dummy/Futurism::HelperTest::GlobalIdableEntity/fake-id", extract_params(element.children.first["data-signed-params"])[:locals][:entity]
  end

  test "renders an eager loading data attribute" do
    post = Post.create title: "Lorem"

    element = Nokogiri::HTML.fragment(futurize(post, extends: :div, eager: true) {})

    assert_equal "true", element.children.first["data-eager"]

    element = Nokogiri::HTML.fragment(futurize(partial: "posts/card", locals: {post: post}, eager: true, extends: :div) {})
    assert_equal "true", element.children.first["data-eager"]
  end

  test "renders an eager loading data attribute for an empty placeholder block" do
    post = Post.create title: "Lorem"

    element = Nokogiri::HTML.fragment(futurize(post, extends: :div, eager: true) {})

    assert_equal "true", element.children.first["data-eager"]

    element = Nokogiri::HTML.fragment(futurize(partial: "posts/card", locals: {post: post}, extends: :div))
    assert_equal "true", element.children.first["data-eager"]
  end

  test "renders a collection " do
    Post.create title: "Lorem"
    Post.create title: "Lorem2"

    element = Nokogiri::HTML.fragment(futurize(collection: Post.all, extends: :div) {})

    assert_equal({post: "gid://dummy/Post/1", post_counter: 0}, Futurism::MessageVerifier.message_verifier.verify(element.children.first["data-signed-params"])[:locals])
    assert_equal({post: "gid://dummy/Post/2", post_counter: 1}, Futurism::MessageVerifier.message_verifier.verify(element.children.last["data-signed-params"])[:locals])
  end

  test "renders a collection with multi-word object" do
    ActionItem.create description: "Do this"
    ActionItem.create description: "Do that"

    element = Nokogiri::HTML.fragment(futurize(collection: ActionItem.all, extends: :div) {})

    assert_equal({action_item: "gid://dummy/ActionItem/1", action_item_counter: 0}, Futurism::MessageVerifier.message_verifier.verify(element.children.first["data-signed-params"])[:locals])
    assert_equal({action_item: "gid://dummy/ActionItem/2", action_item_counter: 1}, Futurism::MessageVerifier.message_verifier.verify(element.children.last["data-signed-params"])[:locals])
  end

  def verifier
    Futurism::MessageVerifier.message_verifier
  end

  def extract_params(params)
    verifier.verify(params)
  end

  def sign_params(params)
    verifier.generate(params)
  end
end
