import { Controller } from "stimulus"

export default class extends Controller {
  // static targets = [ "output" ]

  connect() {
    navigator.geolocation.getCurrentPosition((position) => {
      localStorage.setItem("user_latitude", position.coords.latitude)
      localStorage.setItem("user_longitude", position.coords.longitude)
      // console.log(position.coords.latitude, position.coords.longitude);
    })
  }
}
