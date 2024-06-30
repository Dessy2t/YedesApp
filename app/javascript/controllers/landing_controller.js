import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="landing"
export default class extends Controller {
  static targets = ['login', 'guest', 'google']
  signup() {
    this.loginTarget.className = 'hidden'
    this.guestTarget.className = 'hidden'
    this.googleTarget.className = 'hidden'
    this.guestTarget.id = 'hidden'
  }
}
