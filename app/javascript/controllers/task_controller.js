import { Controller } from "stimulus";
import { fetchWithToken } from "../utils/fetch_with_token";

export default class extends Controller {
  static targets = ['form', 'card', 'modal'];

  submit(event) {
    event.preventDefault();

    $(`#description-${this.formTarget.dataset.taskId}`).modal('hide')
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
      headers: { 'Accept': 'text/plain' }
    })
      .then(response => response.text())
      .then((data) => {
        this.cardTarget.outerHTML = data
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