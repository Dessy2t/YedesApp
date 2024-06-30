import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav"
export default class extends Controller {
    static targets = ['menu', 'pic']
    display() {
       this.menuTarget.className == 'hidden' ? this.menuTarget.className = 'nav-menu' : this.menuTarget.className = 'hidden'
    }
}
