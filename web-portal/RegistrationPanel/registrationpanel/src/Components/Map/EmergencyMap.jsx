import React, { useEffect } from 'react';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import 'leaflet-routing-machine';
import 'leaflet-routing-machine/dist/leaflet-routing-machine.css';

const EmergencyMap = ({ userLat, userLng, targetLat, targetLng }) => {
  useEffect(() => {
    const map = L.map('emergency-map', {
      center: [userLat, userLng],
      zoom: 13,
      zoomControl: false,
    });

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors',
    }).addTo(map);

    L.marker([userLat, userLng]).addTo(map).bindPopup('Hospital').openPopup();
    L.marker([targetLat, targetLng]).addTo(map).bindPopup('Patient').openPopup();

    // Blue Route
    const control = L.Routing.control({
      waypoints: [
        L.latLng(userLat, userLng),
        L.latLng(targetLat, targetLng),
      ],
      routeWhileDragging: false,
      draggableWaypoints: false,
      addWaypoints: false,
      showAlternatives: false,
      createMarker: () => null,
      lineOptions: {
        styles: [{ color: 'blue', weight: 4 }]
      }
    }).addTo(map);

    let labelMarker = null;

    control.on('routesfound', (e) => {
      const route = e.routes[0];
      const summary = route.summary;
      const distance = (summary.totalDistance / 1000).toFixed(2);
      const duration = (summary.totalTime / 60).toFixed(1);
      const midLat = (userLat + targetLat) / 2;
      const midLng = (userLng + targetLng) / 2;

      function getZoomStyle(zoom) {
        const width = 100 + (zoom - 10) * 20;
        const fontSize = 12 + (zoom - 10) * 1.5;
        return { width, fontSize };
      }

      function createInfoHTML({ width, fontSize }) {
        return `
          <div style="
            background: white;
            padding: 8px 12px;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            font-size: ${fontSize}px;
            width: ${width}px;
          ">
            <b>Distance:</b> ${distance} km<br><b>Time:</b> ${duration} min
          </div>
        `;
      }

      const zoom = map.getZoom();
      const style = getZoomStyle(zoom);

      labelMarker = L.marker([midLat, midLng], {
        icon: L.divIcon({
          className: '',
          html: createInfoHTML(style),
          iconSize: [0, 0],
          iconAnchor: [0, 0],
        }),
      }).addTo(map);

      map.on('zoomend', () => {
        const newZoom = map.getZoom();
        const newStyle = getZoomStyle(newZoom);
        labelMarker.setIcon(
          L.divIcon({
            className: '',
            html: createInfoHTML(newStyle),
            iconSize: [0, 0],
            iconAnchor: [0, 0],
          })
        );
      });
    });

    // Purple Route
    const customLat = 22.648599;
    const customLng = 88.411146;

    const purpleIcon = L.icon({
  iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-violet.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

    L.marker([customLat, customLng], { icon: purpleIcon }).addTo(map).bindPopup('AMB-694039').openPopup();
    L.Routing.control({
      waypoints: [
        L.latLng(customLat, customLng),
        L.latLng(targetLat, targetLng),
      ],
      routeWhileDragging: false,
      draggableWaypoints: false,
      addWaypoints: false,
      showAlternatives: false,
      createMarker: () => null,
      lineOptions: {
        styles: [{ color: 'purple', weight: 4, opacity: 0.8 }]
      }
    }).addTo(map);

    return () => {
      map.remove();
    };
  }, [userLat, userLng, targetLat, targetLng]);

  return <div id="emergency-map" style={{ height: '800px', width: '100%' }}></div>;
};

export default EmergencyMap;
