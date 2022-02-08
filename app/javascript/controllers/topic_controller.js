import { Controller } from "stimulus";
import { fetchWithToken } from "../utils/fetch_with_token";

export default class extends Controller {
  static targets = ['rules', 'btn'];

  read(event) {
    event.preventDefault();

    const topicId = this.btnTarget.dataset.topicId
    const url = `/topics/${topicId}/user_topics`

    fetchWithToken(url, {
      method: 'POST',
      headers: { 'Accept': 'text/plain' },
    })
      .then(response => response.text())
      .then((data) => {
        this.rulesTarget.outerHTML = ""
      })
  }
}