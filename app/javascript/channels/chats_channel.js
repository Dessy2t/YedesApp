import consumer from "channels/consumer"

    consumer.subscriptions.create({channel: "ChatsChannel"}, {
      connected() {
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        function getUser() {
          const request = new XMLHttpRequest()
          request.open("GET",'https://socialapp-x98o.onrender.com/current_user', false);
          request.send();
          return JSON.parse(request.response)['user']
        }
        let currentUser = getUser()
        let chatId = data.chat_id
        const chatBox = document.querySelector(`a[data-chat-id="${chatId}"]`)
        if (data.is_date) {}
        else { this.template2(chatBox,data, currentUser) }
        if (data.chat_id == chatId) {
          const messageDisplay = document.querySelector('#messages')
          messageDisplay.insertAdjacentHTML('beforeend', this.template(data, currentUser))}
      },
      template(data, currentUser) {
        const messageInput = document.querySelector('#message-input')
        messageInput.value = ''
        if (data.is_date == true) {
          return `<div class='chat-date'>
                    <p class='date'>${data.message}</p>
                  </div>`
        }
        let firstDiv = ''
        if (data.current_user == currentUser) {
          firstDiv = '<div class="chat-message-user">'
        }
        else {
          firstDiv = '<div class="chat-message">'
        }
        return `${firstDiv}
                    <p>${data.message}</p>
                    <p class="message-date">${data.date}</p>
                </div>`
      },
      template2(chat, data, currentUser) {
        if (chat.querySelector('#user-last-message') == null) {
          chat.querySelector('.last').insertAdjacentHTML('beforeend', '<p class="post-user" id="user-last-message"></p>')
        }
        if (data.current_user == currentUser) {
        chat.querySelector('#user-last-message').textContent = `You: ${data.message}`}
        else {
          chat.querySelector('#user-last-message').textContent = data.message
          let count = chat.querySelector('.messages-count')
          if (count == null) {
            return chat.querySelector('.last').insertAdjacentHTML('beforeend', "<div class='messages-count'>1</div>")}
          else {
              count.textContent = parseInt(count.textContent) + 1
            }
        }
    }
})
