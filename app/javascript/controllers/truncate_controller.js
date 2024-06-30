import { Controller } from "@hotwired/stimulus"

let content = ''

// Connects to data-controller="truncate"
export default class extends Controller {
    static targets = ['output', 'seeMore']
    connect() {
       content = this.outputTarget.textContent
       this.outputTarget.textContent = content.substring(0,150)
       if (content.length < 150) {this.seeMoreTarget.textContent = ''}
    }
    more() {
       console.log(content)
       this.seeMoreTarget.textContent = ''
       this.outputTarget.textContent = content
    }
}
