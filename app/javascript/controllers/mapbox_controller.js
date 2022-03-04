import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

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
      center: [ localStorage.getItem("user_longitude"), localStorage.getItem("user_latitude") ]
    })


    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    const userMarker = new mapboxgl.Marker({color: "#FF0000"})
      .setLngLat([ localStorage.getItem("user_longitude"), localStorage.getItem("user_latitude") ])
      .addTo(this.map);
    this.markersValue.forEach((marker) => {
      const locationMarker = new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
      const locationCard = this.locationTargets.find(target => target.dataset.locationId == marker.id)
      const distance = userMarker.getLngLat().distanceTo(locationMarker.getLngLat())
      if(distance > 1000) {
        const disFormat = (distance/1000).toFixed(1)
        locationCard.insertAdjacentHTML('beforeend', `${disFormat} Km`)
      } else {
        locationCard.insertAdjacentHTML('beforeend', `${Math.round(distance)} m`)
      }
      });

  }
  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    // this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    bounds.extend([ localStorage.getItem("user_longitude"), localStorage.getItem("user_latitude") ])
    this.map.fitBounds(bounds, { padding: 90, maxZoom: 14, duration: 0 })
  }
}
