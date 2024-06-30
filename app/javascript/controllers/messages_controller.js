import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
    static targets = ['chat']
    scroll() {
       let id = this.chatTarget.dataset.chatId
       let chatBox = document.querySelector(`a[data-chat-id="${id}"]`)
       let token = document.querySelector('meta[name="csrf-token"').content
       fetch(`https://socialapp-x98o.onrender.com/messages_read?chat_id=${id}&message=seen`, {'method': 'POST',
                                                  headers: {'Content-Type': 'application/json',
                                                            'X-CSRF-Token': token}})
       let lastDiv = chatBox.children[1].children[1]
       if (lastDiv.children[1] != null) {
          lastDiv.removeChild(lastDiv.children[1])
        }
    }
}
