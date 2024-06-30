import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="friend-requests"
export default class extends Controller {
  static targets = ['button', 'frequest', 'count', 'hid', 'show']
  change() {
    this.buttonTarget.classList.remove('unfocused')
    this.buttonTarget.classList.add('request-sent')
    this.buttonTarget.textContent = 'Request sent'
    this.buttonTarget.disabled = true
  }
  destroy() {
    this.frequestTarget.className = 'hidden'
    this.dispatch('moveCount')
  }
  clear() {
    this.countTarget.className = 'hidden'
  }
  ignored() {
    this.hidTarget.className = 'list-request-item'
    this.showTarget.className = 'hidden'
  }
}
