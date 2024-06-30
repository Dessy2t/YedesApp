import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="popover"
export default class extends Controller {
    static targets = ['div']
    close() {
       this.divTarget.style.display = 'none'
    }
}
