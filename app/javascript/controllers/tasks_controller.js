import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['createForm', 'list', 'input'];

  submit(event) {
    event.preventDefault();

    const url = this.createFormTarget.action
    fetch(url, {
      method: 'POST',
      headers: { 'Accept': 'text/plain' },
      body: new FormData(this.createFormTarget)
    })
      .then(response => response.text())
      .then((data) => {
        this.listTarget.insertAdjacentHTML('afterbegin', data)
        this.inputTarget.value = ""
      })
  }
}