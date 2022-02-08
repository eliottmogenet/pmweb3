import { Controller } from "stimulus";
import { fetchWithToken } from "../utils/fetch_with_token";

export default class extends Controller {
  static targets = ['form', 'descrForm', 'card', 'modal', 'title', 'pen', 'titleForm'];

  togglePen(event) {
    event.preventDefault()

    this.penTarget.classList.toggle("invisible")
  }
  toggleForm(event) {
    event.preventDefault()

    this.titleFormTarget.classList.remove("d-none")
    this.titleTarget.classList.add("d-none")
  }

  submit(event) {
    event.preventDefault();

    const url = this.formTarget.action
    fetch(url, {
      method: 'PATCH',
      headers: { 'Accept': 'text/plain' },
      body: new FormData(this.formTarget)
    })
      .then(response => response.text())
      .then((data) => {
        this.cardTarget.outerHTML = data
      })
  }
  
  updateDescr(event) {
    event.preventDefault();

    $(`#description-${this.descrFormTarget.dataset.taskId}`).modal('hide')
    const url = this.descrFormTarget.action
    fetch(url, {
      method: 'PATCH',
      headers: { 'Accept': 'text/plain' },
      body: new FormData(this.descrFormTarget)
    })
      .then(response => response.text())
      .then((data) => {
        this.cardTarget.outerHTML = data
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
        this.cardTarget.outerHTML = data
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
        this.cardTarget.outerHTML = data.partial
        const tokenTotal = document.getElementById("tokenUserTotal")

        if (tokenTotal && parseInt(tokenTotal.dataset.id) == data.user_id) {
          tokenTotal.innerText = data.user_total
        }
      })
  }

  vote(event) {
    event.preventDefault()

    const id = this.cardTarget.dataset.id
    const url = `/tasks/${id}/vote`
    fetchWithToken(url, {
      method: 'PATCH',
      headers: { 'Accept': 'text/plain' }
    })
      .then(response => response.text())
      .then((data) => {
        this.cardTarget.outerHTML = data
      })
  }

  archive(event) {
    event.preventDefault()

    const id = this.cardTarget.dataset.id
    const url = `/tasks/${id}/archive`
    fetchWithToken(url, {
      method: 'PATCH',
      headers: { 'Accept': 'text/plain' }
    })
      .then(response => response.text())
      .then((data) => {
        this.cardTarget.outerHTML = ""
      })
  }
}