/* global HTMLTableRowElement */

import { extendElementWithIntersectionObserver } from './futurism_utils'

export default class FuturismTableRow extends HTMLTableRowElement {
  connectedCallback () {
    extendElementWithIntersectionObserver(this)
  }
}
