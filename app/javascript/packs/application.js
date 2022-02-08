// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
import { initProjectCable } from '../channels/project_channel';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  initProjectCable();

  // const shareBtn = document.getElementById("share")
  // shareBtn.addEventListener("click", (event) => {
  //   let text = event.currentTarget.dataset.url;
  //   navigator.clipboard.writeText(text)
  //     .then(() => {

  //       $('[data-toggle="tooltip"]').tooltip('dispose')
  //       $('[data-toggle="tooltip"]').tooltip({ title: "Copied to clipboard!" })
  //       $('[data-toggle="tooltip"]').tooltip('show')
  //     })
  //     .catch(err => {
  //       alert('Error in copying text: ', err);
  //     });
  // })

  $(function () {
    $('[data-toggle="tooltip"]').tooltip({title: "Copy link to clipboard"})
  })
});

import "controllers"










