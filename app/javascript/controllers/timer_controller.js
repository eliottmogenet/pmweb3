import { Controller } from "stimulus";
import { fetchWithToken } from "../utils/fetch_with_token";

export default class extends Controller {
  static targets = ['container', 'form'];

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
        this.containerTarget.innerHTML = data
      })
  }

  reset(event) {
    event.preventDefault();

    const url = `/topics/${event.currentTarget.dataset.id}/reset_time`
    fetchWithToken(url, {
      method: 'PATCH',
      headers: { 'Accept': 'text/plain' }
    })
      .then(response => response.text())
      .then((data) => {
        this.containerTarget.innerHTML = data
      })
  }
}