import { Controller } from "stimulus";
import { fetchWithToken } from "../utils/fetch_with_token";

export default class extends Controller {
  static targets = ['form', 'card'];

  submit(event) {
    event.preventDefault();

    console.log("Hello")
    const url = this.formTarget.action
    fetch(url, {
      method: 'PATCH',
      headers: { 'Accept': 'application/json' },
      body: new FormData(this.formTarget)
    })
      .then(response => response.json())
      .then((data) => {
        // this.cardTarget.outerHTML = data.partial
        // document.getElementById("tokenTotal").innerHTML = parseInt(data.total)
        // document.getElementById("filtersContainer").innerHTML = data.filters
      })
  }

  makePublic(event) {
    event.preventDefault()

    const id = this.cardTarget.dataset.id
    const url = `/tasks/${id}/mark_as_public`
    fetchWithToken(url, {
      method: 'PATCH',
      headers: { 'Accept': 'text/plain' }
    })
      .then(response => response.text())
      .then((data) => {
        // this.cardTarget.outerHTML = data
      })
  }

  markAsDone(event) {
    event.preventDefault()

    const id = this.cardTarget.dataset.id
    const url = `/tasks/${id}/mark_as_done`
    fetchWithToken(url, {
      method: 'PATCH',
      headers: { 'Accept': 'application/json' }
    })
      .then(response => response.json())
      .then((data) => {
        // this.cardTarget.outerHTML = data.partial
        // document.getElementById("tokenSubTotal").innerHTML = parseInt(data.subtotal)
        // document.getElementById("tokenUserTotal").innerHTML = parseInt(data.usertotal)
      })    
  }
}