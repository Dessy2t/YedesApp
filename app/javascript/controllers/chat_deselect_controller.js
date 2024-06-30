import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-deselect"
export default class extends Controller {
  static targets = ['chat']
  clear() {
    this.chatTargets.forEach(div => div.style.backgroundColor = 'white')
  }
}
