import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder";

const leWagonLat = 35.633868;
const leWagonLng = 139.708205;
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    userAsset: String,
    userId: String,
    locationUserId: String
  }
  static targets = ["location", "map"];

  async connect() {
    console.log(this.userIdValue)
    console.log(this.locationUserIdValue)
    const geo_location = await this.#getUserLocation()
    const user_location = geo_location.coords
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/streets-v10?optimize=true",
      center: [user_location.longitude, user_location.latitude]
    });

    this.#addMarkersToMap(user_location);
    this.#fitMapToMarkers(user_location);

    this.map.addControl(
      new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        mapboxgl: mapboxgl,
      })
    );
  }

  async #addMarkersToMap(user_location) {
    // Create a HTML element for your custom marker for the user
    console.log(this.userIdValue, this.locationUserIdValue)
    if (this.#showPathName() && this.#userOwnLocation(this.userIdValue, this.locationUserIdValue)) {
      this.#createUserMarker(user_location)
    } else {
      this.#createUserMarker(user_location)
    }


      // Create marker and info window for each locations
    this.markersValue.forEach( async (marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window)
      const customMarker = document.createElement("div")

      // Create a HTML element for your custom marker
      customMarker.className = "marker"
      customMarker.style.backgroundImage = `url('${marker.image_url}')`
      customMarker.style.backgroundSize = "cover"
      customMarker.style.width = "35px"
      customMarker.style.height = "40px"

      const locationMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map);
      const locationCard = this.locationTargets.find(
        (target) => target.dataset.locationId == marker.id
      );

      if (this.#showPathName() && this.#userOwnLocation(this.userIdValue, this.locationUserIdValue)) {
      const distance = userMarker
        .getLngLat()
        .distanceTo(locationMarker.getLngLat());
      this.#formatAndInsertDistance(distance, locationCard);
        const routesCoords = await this.#fetchRoutes(marker, user_location);
        this.#addRoutes(routesCoords);
      }
    });
    if (!this.#showPathName()) {
      new mapboxgl.Marker(userCustomMarker)
        .setLngLat([user_location.longitude, user_location.latitude])
        .addTo(this.map);
    }
  }

  #fitMapToMarkers(user_location) {
    const bounds = new mapboxgl.LngLatBounds();
    if (this.#showPathName()) {
      this.markersValue.forEach((marker) =>
        bounds.extend([marker.lng, marker.lat])
      );
    }
    bounds.extend([user_location.longitude, user_location.latitude]);
    this.map.fitBounds(bounds, {
      padding: 90,
      maxZoom: this.#showPathName() ? 15 : 13,
      duration: 0,
    });
  }

  #formatAndInsertDistance(distance, htmlElement) {
    const distFormat = (distance / 1000).toFixed(1);
    htmlElement.querySelector(
      ".distance"
    ).innerHTML = `<i class="fas fa-map-marker-alt"></i> ${distFormat} Km`;
  }

  async #fetchRoutes(destination, user_location) {
    const url = `https://api.mapbox.com/directions/v5/mapbox/walking/${user_location.longitude},${user_location.latitude};${destination.lng},${destination.lat}?geometries=geojson&access_token=${this.apiKeyValue}`;
    const routes = await fetch(url);
    const data = await routes.json();
    return data.routes[0].geometry.coordinates;
  }

  #addRoutes(routeCoordinates) {
    this.map.on("load", () => {
      this.map.addSource("route", {
        type: "geojson",
        data: {
          type: "Feature",
          properties: {},
          geometry: {
            type: "LineString",
            coordinates: routeCoordinates,
          },
        },
      });
      this.map.addLayer({
        id: "route",
        type: "line",
        source: "route",
        layout: {
          "line-join": "round",
          "line-cap": "round",
        },
        paint: {
          "line-color": "#FF0000",
          "line-width": 6,
        },
      });
    });
  }

  #showPathName() {
    return /\/locations\/\d+.*/.test(window.location.pathname);
  }

  #getUserLocation() {
    return new Promise((res, rej) => {
      navigator.geolocation.getCurrentPosition(res, rej);
    });
  }

  #createUserMarker(user_location) {
    var userCustomMarker = document.createElement("div")
      userCustomMarker.className = "marker"
      userCustomMarker.style.backgroundImage = `url('${JSON.parse(this.userAssetValue).image_url}')`
      userCustomMarker.style.backgroundSize = "contain"
      userCustomMarker.style.backgroundRepeat = "no-repeat"
      userCustomMarker.style.width = "25px"
      userCustomMarker.style.height = "50px"

      var userMarker = new mapboxgl.Marker(userCustomMarker)
        // [ localStorage.getItem("user_longitude"), localStorage.getItem("user_latitude") ]
        .setLngLat([user_location.longitude, user_location.latitude])
        .addTo(this.map);
  }

  #userOwnLocation(user, location) {
    return user != location
  }

  // #addCurrentLocationButton() {
  //   // Adds a current location button.
  //   this.map.addControl(
  //     new mapboxgl.GeolocateControl({
  //       positionOptions: {
  //         enableHighAccuracy: true,
  //       },
  //       trackUserLocation: true,
  //       showUserHeading: true,
  //     })
  //   );
  // }
}
