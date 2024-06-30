import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-select"
export default class extends Controller {
  static targets = ['chat']
  select() {
    this.chatTarget.style.backgroundColor = 'rgba(0, 106, 255, 0.2)'
  }
}
