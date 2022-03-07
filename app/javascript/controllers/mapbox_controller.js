import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

const leWagonLat = 35.633868
const leWagonLng = 139.708205


export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
  }

  static targets = ["location", "map"]

  async connect() {
    const geo_location = await this.#getUserLocation()
    const user_location = geo_location.coords
    console.log({user_location})
    console.log('Hello world')
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [ user_location.longitude, user_location.latitude ]
    })

    this.#addMarkersToMap(user_location)
    this.#fitMapToMarkers(user_location)

    // if (this.#pathName()) {
    //   this.#addRoutes()
    // }
  }

  async #addMarkersToMap(user_location) {
    // Create a HTML element for your custom marker
    const userCustomMarker = document.createElement("div")
    userCustomMarker.className = "marker"
    userCustomMarker.style.backgroundImage = `url('../assets/man.png')`
    userCustomMarker.style.backgroundSize = "contain"
    userCustomMarker.style.width = "40px"
    userCustomMarker.style.height = "40px"
    const userMarker = new mapboxgl.Marker(userCustomMarker)
    // [ localStorage.getItem("user_longitude"), localStorage.getItem("user_latitude") ]
      .setLngLat([ user_location.longitude, user_location.latitude ])
      .addTo(this.map);
    this.markersValue.forEach( async (marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window)
      const customMarker = document.createElement("div")

      // Create a HTML element for your custom marker
      customMarker.className = "marker"
      customMarker.style.backgroundImage = `url('${marker.image_url}')`
      customMarker.style.backgroundSize = "contain"
      customMarker.style.width = "30px"
      customMarker.style.height = "30px"

      const locationMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
      const locationCard = this.locationTargets.find(target => target.dataset.locationId == marker.id)
      const distance = userMarker.getLngLat().distanceTo(locationMarker.getLngLat())
      this.#formatAndInsertDistance(distance, locationCard)
      if (this.#showPathName()) {
        const routesCoords = await this.#fetchRoutes(marker, user_location)
        this.#addRoutes(routesCoords)
      }
    });
    new mapboxgl.Marker(userCustomMarker)
    .setLngLat([ user_location.longitude, user_location.latitude ])
    .addTo(this.map);
  }

  #fitMapToMarkers(user_location) {
    const bounds = new mapboxgl.LngLatBounds()
    if (this.#showPathName()) {
      this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    }
    bounds.extend([ user_location.longitude, user_location.latitude ])
    this.map.fitBounds(bounds, { padding: 90, maxZoom: (this.#showPathName() ? 15 : 13), duration: 0 })
  }

  #formatAndInsertDistance(distance, htmlElement) {
    // const target = document.getElementsByClassName('distance')
    const distFormat = (distance/1000).toFixed(1)
    htmlElement.querySelector('.distance').innerHTML = `<i class="fas fa-map-marker-alt"></i> ${distFormat} Km`
  }

  async #fetchRoutes(destination, user_location) {
    const url = `https://api.mapbox.com/directions/v5/mapbox/walking/${user_location.longitude},${user_location.latitude};${destination.lng},${destination.lat}?geometries=geojson&access_token=${this.apiKeyValue}`
    const routes = await fetch(url)
    const data = await routes.json()
    // await fetch(url).then(res => res.json()).then(data => {
    //   console.log(data)
    // })
      return data.routes[0].geometry.coordinates
  }

  #addRoutes(routeCoordinates) {
    this.map.on('load', () => {
      this.map.addSource('route', {
        'type': 'geojson',
        'data': {
          'type': 'Feature',
          'properties': {},
          'geometry': {
            'type': 'LineString',
            'coordinates': routeCoordinates
          }
        }
      });
      this.map.addLayer({
        'id': 'route',
        'type': 'line',
        'source': 'route',
        'layout': {
          'line-join': 'round',
          'line-cap': 'round'
        },
        'paint': {
          'line-color': '#FF0000',
          'line-width': 6
        }
      });
    })
  }

  #showPathName() {
    return (/\/locations\/\d+.*/).test(window.location.pathname)
  }

  #getUserLocation() {
    // const coords = {}
    // navigator.geolocation.getCurrentPosition((position) => {
    //   coords.latitude = position.coords.latitude
    //   coords.longitude = position.coords.longitude
    //   // localStorage.setItem("user_latitude", position.coords.latitude)
    //   // localStorage.setItem("user_longitude", position.coords.longitude)
    // })
    // return coords
    return new Promise((res, rej) => {
      navigator.geolocation.getCurrentPosition(res, rej)
    })
  }

  #addCurrentLocationButton() {
    // Adds a current location button.
    this.map.addControl(
      new mapboxgl.GeolocateControl({
        positionOptions: {
          enableHighAccuracy: true,
        },
        trackUserLocation: true,
        showUserHeading: true,
      })
    );
  }
}
