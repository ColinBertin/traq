import { Controller } from "stimulus"

export default class extends Controller {
  // static targets = [ "output" ]

  connect() {
    navigator.geolocation.getCurrentPosition((position) => {
      localStorage.setItem("latitude", position.coords.latitude)
      localStorage.setItem("longitude", position.coords.longitude)
      console.log(position.coords.latitude, position.coords.longitude);
    });
  }
}
