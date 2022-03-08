import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count", "form"]

  connect() {
    console.log(this.countTarget)
    console.log(this.formTarget)
  }

  send(event) {
    event.preventDefault()

    fetch(this.formTarget.action, {
      method: "POST",
      headers: { "Accept": "application/json", "X-CSRF-Token": csrfToken() },
      body: new FormData(this.formTarget)
    })
      .then(response => response.json())
      .then((data) => {
        console.log(data)
      })
  }
}
