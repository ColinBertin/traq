import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

const leWagonLat = 35.6290224
const leWagonLng = 139.7006397

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
      // center: [ leWagonLng, leWagonLat ]
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.#addRoutes()
    console.log(window.location.pathname)
  }

  #addMarkersToMap() {
    const userMarker = new mapboxgl.Marker({color: "#FF0000"})
    // [ localStorage.getItem("user_longitude"), localStorage.getItem("user_latitude") ]
      .setLngLat([ leWagonLng, leWagonLat ])
      .addTo(this.map)
      this.markersValue.forEach((marker) => {
        const locationMarker = new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
        this.#fetchRoutes(marker)
      const locationCard = this.locationTargets.find(target => target.dataset.locationId == marker.id)
      const distance = userMarker.getLngLat().distanceTo(locationMarker.getLngLat())
      if(distance >= 1000) {
        const disFormat = Math.round((distance/1000))
        locationCard.insertAdjacentHTML('beforeend', `<p class="card-distance"><i class="fas fa-map-marker-alt"></i> ${disFormat} Km</p>`)
      } else {
        locationCard.insertAdjacentHTML('beforeend', `<p class="card-distance"><i class="fas fa-map-marker-alt"></i> ${Math.round(distance)} m</p>`)
      }
    });
    new mapboxgl.Marker({color: "#FF0000"})
    .setLngLat([ leWagonLng, leWagonLat ])
    .addTo(this.map);
  }
  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    bounds.extend([ leWagonLng, leWagonLat ])
    this.map.fitBounds(bounds, { padding: 90, maxZoom: 13, duration: 0 })
  }
  #fetchRoutes(destination) {
    // const url = "https://api.mapbox.com/directions/v5/mapbox/cycling/-84.518641,39.134270;-84.512023,39.102779?geometries=geojson&access_token=pk.eyJ1IjoiY29saW5hcmlvIiwiYSI6ImNrejd5bzR4bjFmM3AzMXR2NmNmMWRpZnAifQ.R0SOoEArqe9K1ggQnatU6g"
    const url = `https://api.mapbox.com/directions/v5/mapbox/walking/${leWagonLng},${leWagonLat};${destination.lng},${destination.lat}?geometries=geojson&access_token=${this.apiKeyValue}`
    fetch(url).then(response => response.json()).then(data => {
      routeCoordinates = data.routes[0].geometry.coordinates
      console.log(data.routes[0].distance)
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
}
