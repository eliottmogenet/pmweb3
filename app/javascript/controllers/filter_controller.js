import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['form', 'input', 'list', 'all'];

  toggleAll(event) {
    event.preventDefault()

    const url = `${this.formTarget.action}`
    this.inputTargets.forEach((input) => {
      input.checked = false
    })
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then((data) => {
        this.listTarget.innerHTML = data;
        window.history.pushState('', '', '?')
      })
  }

  apply(event) {
    event.preventDefault()

    let query = "?"
    this.allTarget.checked = false
    this.inputTargets.forEach((input) => {
      if (input.checked) {
        query += `${input.name}=${input.value}&`
      }
    })

    const url = `${this.formTarget.action}${query}`
    console.log(url)
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(response => response.text())
      .then((data) => {
        this.listTarget.innerHTML = data;
        window.history.pushState('', '', query)
      })
  }
}
