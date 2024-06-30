// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// const img1 = document.querySelector('.bg-1')
// const img2 = document.querySelector('.bg-2')
// const img3 = document.querySelector('.bg-3')
// const credits1 = document.querySelector('.credits-1')
// const credits2 = document.querySelector('.credits-2')
// const credits3 = document.querySelector('.credits-3')
// let images = [img1, img2, img3]
// let credits = [credits1, credits2, credits3]
// let currentImage = img1
// let currentCredits = credits1
// function changeImage() {
//     currentImage.classList.remove('background-img')
//     currentCredits.classList.remove('credits')
//     let index = images.indexOf(currentImage)
//     if (index == 2) {index = -1}
//     currentImage = images[index+1]
//     currentCredits = credits[index+1]
//     currentImage.classList.add('background-img')
//     currentCredits.classList.add('credits')
// }
// const signUp = document.querySelector('#sign-up-link')
// signUp.addEventListener('click', function() {
//     signUp.parentElement.parentElement.id = 'landing-right-form'
// })
// setInterval(changeImage, 5000)
// let like = document.querySelectorAll('#reactions > a')
// const feed = document.querySelector('#new-post > form > .button')
// function likePost(node) {
//     node.addEventListener('click', function(e) {
//         let count = e.currentTarget.parentElement.firstElementChild
//         console.log(e.currentTarget.parentElement.firstElementChild)
//         if (e.currentTarget.classList.contains('unliked')) {count.textContent++}
//         else {count.textContent--}
//         e.currentTarget.classList.toggle('unliked')
// })}
// like.forEach(likePost)
// feed.addEventListener('click', function() {
//     like = document.querySelectorAll('#reactions > a')
//     like.forEach(likePost)
// })

// const notis = document.querySelectorAll('.noti')
// const notiRead = document.querySelector('.notifications-read')
// const notiCount = document.querySelector('.hero-count')
// notiRead.addEventListener('click', function() {
//     for (const noti of notis) {
//         noti.className = 'noti-seen'
//         notiCount.textContent = ''
//         notiCount.className = 'noti-count-zero'
//     }
// })
import "channels"
