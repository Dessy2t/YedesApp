import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pagination"
export default class extends Controller {
    static targets = ['link', 'maxPages']
    update() {
        let href = this.linkTarget.href.split('=')
        if (href[1]++ == this.maxPagesTarget.textContent) {
           this.linkTarget.textContent = 'No more posts'
           return this.linkTarget.href = 'javascript:void(0)'
        }
        href[1] = `=${href[1]++}`
        this.linkTarget.href = href.join('')
    }
}
