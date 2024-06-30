import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forms"
export default class extends Controller {
  static targets = ['input']

  clear() {
    this.inputTarget.reset()
  }
}
