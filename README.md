# Futurism
[![Twitter follow](https://img.shields.io/twitter/follow/julian_rubisch?style=social)](https://twitter.com/julian_rubisch)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
Lazy-load Rails partials via CableReady

## Facts
- only one dependency: CableReady
- bundle size (without CableReady) is around [~1.04kB](https://bundlephobia.com/result?p=@minthesize/futurism@0.1.3)

## Usage
with a helper in your template

```erb
<%= futurize @posts %>
```

custom `<futurism-element>`s (in the form of a `<div>` or a `<tr is="futurism-table-row">` are rendered. Those custom elements have an `IntersectionObserver` attached that will send a signed global id to an ActionCable channel (`FuturismChannel`) which will then replace the placeholders with the actual resource partial.

With that method, you could lazy load every class that has to_partial_path defined (ActiveModel has by default).

You can pass the placeholder as a block:

```erb
<%= futurize @posts, extends: :tr do %>
  <td class="placeholder"></td>
<% end %>
```

![aa601dec1930151f71dbf0d6b02b61c9](https://user-images.githubusercontent.com/4352208/87131629-f768a480-c294-11ea-89a9-ea0a76ee06ef.gif)

### Partial Path

Remember that you can override the partial path in you models, like so:

```rb
class Post < ApplicationRecord
  def to_partial_path
    "home/post"
  end
end
```

That way you get maximal flexibility when just specifying a single resource.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'futurism'
```

And then execute:
```bash
$ bundle
```

To copy over the javascript files to your application, run

```bash
$ bin/rails futurism:install
```

** ! Note that the installer will run `yarn install @minthesize/futurism` for you ! **

### Manual Installation
After `bundle`, install the Javascript library:

```bash
$ bin/yarn install @minthesize/futurism
```

In your `app/javascript/channels/index.js`, add the following

```js
import * as Futurism

import consumer from './consumer'

Futurism.initializeElements()
Futurism.createSubscription(consumer)
```

## Contributing

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="http://www.julianrubisch.at"><img src="https://avatars0.githubusercontent.com/u/4352208?v=4" width="100px;" alt=""/><br /><sub><b>Julian Rubisch</b></sub></a><br /><a href="https://github.com/julianrubisch/futurism/commits?author=julianrubisch" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/darkrubyist"><img src="https://avatars2.githubusercontent.com/u/11207292?v=4" width="100px;" alt=""/><br /><sub><b>darkrubyist</b></sub></a><br /><a href="https://github.com/julianrubisch/futurism/commits?author=darkrubyist" title="Code">💻</a> <a href="https://github.com/julianrubisch/futurism/commits?author=darkrubyist" title="Documentation">📖</a></td>
    <td align="center"><a href="https://ParamagicDev.github.io/portfolio"><img src="https://avatars2.githubusercontent.com/u/26425882?v=4" width="100px;" alt=""/><br /><sub><b>Konnor Rogers</b></sub></a><br /><a href="https://github.com/julianrubisch/futurism/commits?author=ParamagicDev" title="Code">💻</a></td>
    <td align="center"><a href="https://www.andrewm.codes"><img src="https://avatars1.githubusercontent.com/u/18423853?v=4" width="100px;" alt=""/><br /><sub><b>Andrew Mason</b></sub></a><br /><a href="#maintenance-andrewmcodes" title="Maintenance">🚧</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
