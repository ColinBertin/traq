import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

const leWagonLat = 35.633868
const leWagonLng = 139.708205
let routeCoordinates

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
  }

  static targets = ["location", "map"]

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [ leWagonLng, leWagonLat ]
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    if (this.#pathName()) {
      this.#addRoutes()
    }
  }

  #addMarkersToMap() {
    // Create a HTML element for your custom marker
    const userCustomMarker = document.createElement("div")
    userCustomMarker.className = "marker"
    userCustomMarker.style.backgroundImage = `url('../assets/man.png')`
    userCustomMarker.style.backgroundSize = "contain"
    userCustomMarker.style.width = "40px"
    userCustomMarker.style.height = "40px"
    const userMarker = new mapboxgl.Marker(userCustomMarker)
    // [ localStorage.getItem("user_longitude"), localStorage.getItem("user_latitude") ]
      .setLngLat([ leWagonLng, leWagonLat ])
      .addTo(this.map);
    this.markersValue.forEach((marker) => {
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
      if (this.#pathName()) {
        this.#fetchRoutes(marker)
        this.#addRoutes()
      }
    });
    new mapboxgl.Marker(userCustomMarker)
    .setLngLat([ leWagonLng, leWagonLat ])
    .addTo(this.map);
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    if (this.#pathName()) {
      this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    }
    bounds.extend([ leWagonLng, leWagonLat ])
    this.map.fitBounds(bounds, { padding: 90, maxZoom: (this.#pathName() ? 15 : 13), duration: 0 })
  }

  #formatAndInsertDistance(distance, htmlElement) {
    // const target = document.getElementsByClassName('distance')
    const distFormat = (distance/1000).toFixed(1)
    htmlElement.insertAdjacentHTML('beforeend', `<p class="card-distance"><i class="fas fa-map-marker-alt"></i> ${distFormat} Km</p>`)

  }

  #fetchRoutes(destination) {
    const url = `https://api.mapbox.com/directions/v5/mapbox/walking/${leWagonLng},${leWagonLat};${destination.lng},${destination.lat}?geometries=geojson&access_token=${this.apiKeyValue}`
    fetch(url).then(response => response.json()).then(data => {
      routeCoordinates = data.routes[0].geometry.coordinates
    })
  }

  #addRoutes() {
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

  #pathName() {
    return (/\/locations\/\d+.*/).test(window.location.pathname)
  }
}
