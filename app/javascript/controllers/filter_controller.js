import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['form', 'input', 'list', 'all'];

  toggleAll(event) {
    event.preventDefault()

    const url = `${this.formTarget.action}?puzzle=true`
    this.inputTargets.forEach((input) => {
      input.checked = false
    })
    fetch(url, { headers: { 'Accept': 'application/json' } })
      .then(response => response.json())
      .then((data) => {
        this.listTarget.innerHTML = data.partial;
        window.history.pushState('', '', '?puzzle=true')
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
    fetch(url, { headers: { 'Accept': 'application/json' } })
      .then(response => response.json())
      .then((data) => {
        this.listTarget.innerHTML = data.partial;
        this.formTarget.outerHTML = data.filters;
        window.history.pushState('', '', query)
      })
  }
}
