import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="friendship"
export default class extends Controller {
  static targets = ['button', 'confirmButton', 'confirmBox']
  destroy() {
    this.buttonTarget.textContent = 'Unfriend'
    this.buttonTarget.className = 'button is-small is-danger'
  }
  restore() {
    this.buttonTarget.textContent = 'Friends'
    this.buttonTarget.className = 'button is-small unfocused'
  }
  confirm() {
    this.confirmBoxTarget.remove()
  }
}
