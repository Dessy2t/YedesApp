import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="likes"
export default class extends Controller {
  static targets = ['button', 'count']
  toggle() {
    let likesCount = parseInt(this.countTarget.textContent)
    this.buttonTarget.className == 'unliked' ? this.countTarget.textContent = likesCount+1 : this.countTarget.textContent = likesCount-1
    this.buttonTarget.classList.toggle('unliked')
  }
  test() {
    console.log('est')
  }
}
