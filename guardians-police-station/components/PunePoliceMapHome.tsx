"use client"
/* eslint-disable @typescript-eslint/no-explicit-any */
import { useEffect } from "react"
import L from "leaflet"
import "leaflet/dist/leaflet.css"

export default function PunePoliceMapHome() {
  useEffect(() => {
    if (typeof window !== "undefined" && !document.getElementById("map")?.hasChildNodes()) {
      const map = L.map("map").setView([18.541348246926415, 73.830273147597], 11)

      // Use a dark-themed tile layer
      L.tileLayer("https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png", {
        attribution:
          '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
        subdomains: "abcd",
        maxZoom: 20,
      }).addTo(map)

      const jurisdictions = [
        { name: "Shivajinagar", color: "#8dd3c7" },
        { name: "Swargate", color: "#8dd3c7" },
        { name: "Kothrud", color: "#8dd3c7" },
        { name: "Yerawada", color: "#ffffb3" },
        { name: "Vishrantwadi", color: "#ffffb3" },
        { name: "Bund Garden", color: "#bebada" },
        { name: "Koregaon Park", color: "#bebada" },
        { name: "Wanowrie", color: "#fb8072" },
        { name: "Bavdhan", color: "#fb8072" },
        { name: "Narhe", color: "#80b1d3" },
        { name: "Dhankawadi", color: "#80b1d3" },
        { name: "Bharati Vidyapeeth Police Station, Dhankawadi", color: "#fdb462" },
        { name: "Bibwewadi", color: "#fdb462" },
        { name: "Hinjewadi", color: "#b3de69" },
        { name: "Deccan", color: "#b3de69" },
        { name: "Camp", color: "#fccde5" },
        { name: "Ramwadi", color: "#fccde5" },
        { name: "Pashan", color: "#d9d9d9" },
        { name: "Aundh", color: "#d9d9d9" },
        { name: "Sinhagad Road", color: "#bc80bd" },
        { name: "Pimpri Police Station", color: "#bc80bd" },
        { name: "Chinchwad Police Station", color: "#ccebc5" },
        { name: "Wakad Police Station", color: "#ccebc5" },
        { name: "Bhosari Police Station", color: "#ffed6f" },
        { name: "Sant Tukaram Nagar Police Station", color: "#ffed6f" },
        { name: "New Sangvi Police Station", color: "#ffed6f" },
      ]

      const geoJSONData: { [key: string]: any } = {
        Shivajinagar: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.85542466968587, 18.519709114787535],
                    [73.81983419710527, 18.527396739919013],
                    [73.82206878023484, 18.54062437624479],
                    [73.8453585511307, 18.56289352525197],
                    [73.86204250891434, 18.546455182955377],
                    [73.85542466968587, 18.519709114787535],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Swargate: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.85601285975385, 18.483422335807372],
                    [73.83778207913869, 18.485767527088758],
                    [73.83614736760039, 18.488644611320908],
                    [73.85635757935235, 18.516802552274566],
                    [73.86942608749455, 18.510311405346698],
                    [73.87738292805827, 18.504450122479877],
                    [73.87618696215223, 18.48648795703505],
                    [73.85601285975385, 18.483422335807372],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Kothrud: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.82427406526638, 18.496742599389613],
                    [73.78834395883771, 18.483980801715038],
                    [73.77477883464589, 18.49291164305764],
                    [73.7961980084053, 18.522061153417223],
                    [73.8185826115838, 18.52518771972383],
                    [73.82427406526638, 18.496742599389613],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Yerawada: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.90328865308554, 18.544753960694806],
                    [73.87874410280607, 18.545887741556502],
                    [73.89594786834449, 18.57418402642297],
                    [73.90328865308554, 18.544753960694806],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Vishrantwadi: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.8453585511307, 18.56289352525197],
                    [73.84509433264215, 18.5726874915411],
                    [73.85548312757554, 18.59534041110737],
                    [73.89373000999721, 18.63094907199791],
                    [73.8960599342244, 18.574539563618913],
                    [73.89594786834449, 18.57418402642297],
                    [73.87874410280607, 18.545887741556502],
                    [73.87591896166529, 18.54410065996391],
                    [73.86204250891434, 18.546455182955377],
                    [73.8453585511307, 18.56289352525197],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Bund Garden": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.87591896166529, 18.54410065996391],
                    [73.87760851540675, 18.540809890942036],
                    [73.86942608749455, 18.510311405346698],
                    [73.85635757935235, 18.516802552274566],
                    [73.85542466968587, 18.519709114787535],
                    [73.86204250891434, 18.546455182955377],
                    [73.87591896166529, 18.54410065996391],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Koregaon Park": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.90328865308554, 18.544753960694806],
                    [73.92748850554551, 18.531663255143226],
                    [73.91632130754908, 18.517524470298063],
                    [73.8936654137818, 18.51768792131742],
                    [73.87760851540675, 18.540809890942036],
                    [73.87591896166529, 18.54410065996391],
                    [73.87874410280607, 18.545887741556502],
                    [73.90328865308554, 18.544753960694806],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Wanowrie: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.87618696215223, 18.48648795703505],
                    [73.87738292805827, 18.504450122479877],
                    [73.8936654137818, 18.51768792131742],
                    [73.91632130754908, 18.517524470298063],
                    [73.92110254188566, 18.442069432870444],
                    [73.87618696215223, 18.48648795703505],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Bavdhan: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.73489101830572, 18.497321226251028],
                    [73.73011070416439, 18.535550664617322],
                    [73.76516885500239, 18.560145278394398],
                    [73.7961980084053, 18.522061153417223],
                    [73.77477883464589, 18.49291164305764],
                    [73.73489101830572, 18.497321226251028],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Narhe: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.83925826429834, 18.45256883519653],
                    [73.82167854738155, 18.4],
                    [73.79407069842014, 18.4],
                    [73.79661617259062, 18.45850877729463],
                    [73.83539708892948, 18.47559219290536],
                    [73.83925826429834, 18.45256883519653],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Dhankawadi: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.84740221624554, 18.45434543052076],
                    [73.83925826429834, 18.45256883519653],
                    [73.83539708892948, 18.47559219290536],
                    [73.83778207913869, 18.485767527088758],
                    [73.85601285975385, 18.483422335807372],
                    [73.85934011176997, 18.467083427168866],
                    [73.84740221624554, 18.45434543052076],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Bharati Vidyapeeth Police Station, Dhankawadi": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.84740221624554, 18.45434543052076],
                    [73.85934011176997, 18.467083427168866],
                    [73.86978673360929, 18.45506108502867],
                    [73.84740221624554, 18.45434543052076],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Bibwewadi: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.92164451836459, 18.44086044177185],
                    [73.86978673360929, 18.45506108502867],
                    [73.85934011176997, 18.467083427168866],
                    [73.85601285975385, 18.483422335807372],
                    [73.87618696215223, 18.48648795703505],
                    [73.92110254188566, 18.442069432870444],
                    [73.92164451836459, 18.44086044177185],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Hinjewadi: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.73536450623008, 18.61781994791546],
                    [73.77147880616268, 18.568364761980682],
                    [73.76516885500239, 18.560145278394398],
                    [73.73011070416439, 18.535550664617322],
                    [73.7, 18.55601940544065],
                    [73.7, 18.63035453743541],
                    [73.73536450623008, 18.61781994791546],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Deccan: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.85635757935235, 18.516802552274566],
                    [73.83614736760039, 18.488644611320908],
                    [73.82427406526638, 18.496742599389613],
                    [73.8185826115838, 18.52518771972383],
                    [73.81983419710527, 18.527396739919013],
                    [73.85542466968587, 18.519709114787535],
                    [73.85635757935235, 18.516802552274566],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Camp: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.86942608749455, 18.510311405346698],
                    [73.87760851540675, 18.540809890942036],
                    [73.8936654137818, 18.51768792131742],
                    [73.87738292805827, 18.504450122479877],
                    [73.86942608749455, 18.510311405346698],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Ramwadi: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.8960599342244, 18.574539563618913],
                    [73.93612607319034, 18.537105944417426],
                    [73.92748850554551, 18.531663255143226],
                    [73.90328865308554, 18.544753960694806],
                    [73.89594786834449, 18.57418402642297],
                    [73.8960599342244, 18.574539563618913],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Pashan: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.8185826115838, 18.52518771972383],
                    [73.7961980084053, 18.522061153417223],
                    [73.76516885500239, 18.560145278394398],
                    [73.77147880616268, 18.568364761980682],
                    [73.77449208613389, 18.569789045927024],
                    [73.82206878023484, 18.54062437624479],
                    [73.81983419710527, 18.527396739919013],
                    [73.8185826115838, 18.52518771972383],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        Aundh: {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.77449208613389, 18.569789045927024],
                    [73.7862531163961, 18.582321668841075],
                    [73.84509433264215, 18.5726874915411],
                    [73.8453585511307, 18.56289352525197],
                    [73.82206878023484, 18.54062437624479],
                    [73.77449208613389, 18.569789045927024],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Sinhagad Road": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.83778207913869, 18.485767527088758],
                    [73.83539708892948, 18.47559219290536],
                    [73.79661617259062, 18.45850877729463],
                    [73.78834395883771, 18.483980801715038],
                    [73.82427406526638, 18.496742599389613],
                    [73.83614736760039, 18.488644611320908],
                    [73.83778207913869, 18.485767527088758],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Pimpri Police Station": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.77985589936604, 18.64882236446391],
                    [73.8225009533133, 18.7],
                    [73.86018720803487, 18.7],
                    [73.79647903780179, 18.621658683064584],
                    [73.77985589936604, 18.64882236446391],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Chinchwad Police Station": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.7619847635441, 18.62545648217462],
                    [73.7701748493807, 18.646829935569052],
                    [73.77985589936604, 18.64882236446391],
                    [73.79647903780179, 18.621658683064584],
                    [73.7937085528462, 18.60968916230464],
                    [73.7619847635441, 18.62545648217462],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Wakad Police Station": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.79410005329957, 18.608405864802844],
                    [73.7862531163961, 18.582321668841075],
                    [73.77449208613389, 18.569789045927024],
                    [73.77147880616268, 18.568364761980682],
                    [73.73536450623008, 18.61781994791546],
                    [73.7619847635441, 18.62545648217462],
                    [73.7937085528462, 18.60968916230464],
                    [73.79410005329957, 18.608405864802844],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Bhosari Police Station": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.89373000999721, 18.63094907199791],
                    [73.85548312757554, 18.59534041110737],
                    [73.81478412144338, 18.6081335233325],
                    [73.86602692507978, 18.7],
                    [73.93512525592111, 18.7],
                    [73.89373000999721, 18.63094907199791],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "Sant Tukaram Nagar Police Station": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.79647903780179, 18.621658683064584],
                    [73.86018720803487, 18.7],
                    [73.86602692507978, 18.7],
                    [73.81478412144338, 18.6081335233325],
                    [73.79410005329957, 18.608405864802844],
                    [73.7937085528462, 18.60968916230464],
                    [73.79647903780179, 18.621658683064584],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
        "New Sangvi Police Station": {
          type: "FeatureCollection",
          features: [
            {
              type: "Feature",
              geometry: {
                type: "Polygon",
                coordinates: [
                  [
                    [73.81478412144338, 18.6081335233325],
                    [73.85548312757554, 18.59534041110737],
                    [73.84509433264215, 18.5726874915411],
                    [73.7862531163961, 18.582321668841075],
                    [73.79410005329957, 18.608405864802844],
                    [73.81478412144338, 18.6081335233325],
                  ],
                ],
              },
              id: "0",
            },
          ],
        },
      }

      jurisdictions.forEach((jurisdiction) => {
        const layer = L.geoJSON(geoJSONData[jurisdiction.name], {
          style: {
            color: "black",
            fillColor: jurisdiction.color,
            fillOpacity: 0.4,
            weight: 2,
          },
        }).addTo(map)

        layer.bindTooltip(jurisdiction.name, { sticky: true })
      })

      const policeStations = [
        { name: "Shivajinagar Police Station", lat: 18.530689746609177, lon: 73.84400666904216 },
        { name: "Swargate Police Station", lat: 18.50100924404835, lon: 73.85917726686567 },
        { name: "Kothrud Police Station", lat: 18.506818984826907, lon: 73.80250255337347 },
        { name: "Yerawada Police Station", lat: 18.55348608584449, lon: 73.89602064856271 },
        { name: "Hadapsar Police Station", lat: 18.501471945848067, lon: 73.9398855996037 },
        { name: "Vishrantwadi Police Station", lat: 18.5647228409569, lon: 73.87753873988258 },
        { name: "Vimantal Police Station", lat: 18.56628366240747, lon: 73.91532759570309 },
        { name: "Bund Garden Police Station", lat: 18.524098396237903, lon: 73.87064568220976 },
        { name: "Koregaon Park Police Station", lat: 18.536729049824785, lon: 73.89524659458651 },
        { name: "Wanowrie Police Station", lat: 18.49862596117177, lon: 73.89497169972935 },
        { name: "Bavdhan Police Station", lat: 18.52352410115479, lon: 73.7797684382798 },
        { name: "Pirangut Police Station", lat: 18.5116669044658, lon: 73.68494329570187 },
        { name: "Narhe Police Station", lat: 18.459881155459634, lon: 73.82048042006963 },
        { name: "Khadakvasla Police Station", lat: 18.461948516090544, lon: 73.77296128035702 },
        { name: "Katraj Police Station", lat: 18.44711427661528, lon: 73.8586573687156 },
        { name: "Dhankawadi Police Station", lat: 18.46560712944284, lon: 73.85462317056732 },
        { name: "Bharati Vidyapeeth Police Station", lat: 18.462280758181674, lon: 73.85817248174101 },
        { name: "Bibwewadi Police Station", lat: 18.467569314808582, lon: 73.86425873988019 },
        { name: "Hinjewadi Police Station", lat: 18.58633705475014, lon: 73.73570278458878 },
        { name: "Deccan Police Station", lat: 18.514420200862222, lon: 73.84049240919414 },
        { name: "Camp Police Station", lat: 18.522857376434096, lon: 73.87527135383388 },
        { name: "Ramwadi Police Station", lat: 18.555876542381103, lon: 73.90560426877153 },
        { name: "Pashan Police Station", lat: 18.538447452988525, lon: 73.798084851523 },
        { name: "Aundh Police Station", lat: 18.562985149236802, lon: 73.81312653988255 },
        { name: "Sinhagad Road Police Station", lat: 18.475190537419262, lon: 73.81373647073964 },
        { name: "Pimpri Police Station", lat: 18.643530783964124, lon: 73.79441965436496 },
        { name: "Nigdi Police Station", lat: 18.662192612461425, lon: 73.77202389755683 },
        { name: "Chinchwad Police Station", lat: 18.633445962549718, lon: 73.77794016242493 },
        { name: "Wakad Police Station", lat: 18.60791386930472, lon: 73.76525023193426 },
        { name: "Ravet Police Station", lat: 18.64206240133166, lon: 73.75545406686915 },
        { name: "Bhosari Police Station", lat: 18.61952442427167, lon: 73.82651730040926 },
        { name: "Sant Tukaram Nagar Police Station", lat: 18.624101514426062, lon: 73.81831163803261 },
        { name: "New Sangvi Police Station", lat: 18.592078192195157, lon: 73.8178899957038 },
      ]

      policeStations.forEach((station) => {
        L.marker([station.lat, station.lon])
          .addTo(map)
          .bindPopup(`<b>${station.name}</b><br>Latitude: ${station.lat}<br>Longitude: ${station.lon}`)
      })
    }
  }, [])

  return <div id="map" style={{ width: "100%", height: "500px", backgroundColor:"black" }}></div>
}

