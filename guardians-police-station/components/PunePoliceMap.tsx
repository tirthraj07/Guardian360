"use client"

import { useEffect, useRef } from "react"
import L from "leaflet"
import "leaflet/dist/leaflet.css"


type Case = {
  id: string
  location: string
  jurisdiction: string
  // Add other necessary fields
}

type PunePoliceMapProps = {
  cases: Case[]
  selectedCase: Case | null
}

export default function PunePoliceMap({ cases, selectedCase }: PunePoliceMapProps) {
  const mapRef = useRef<L.Map | null>(null)
  const markersRef = useRef<L.Marker[] | null>([])

  useEffect(() => {
    if (typeof window !== "undefined" && !mapRef.current) {
      mapRef.current = L.map("map").setView([18.541348246926415, 73.830273147597], 11)

      // Use a dark-themed tile layer
      L.tileLayer("https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png", {
        attribution:
          '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
        subdomains: "abcd",
        maxZoom: 20,
      }).addTo(mapRef.current)
    }

    return () => {
      if (mapRef.current) {
        mapRef.current.remove()
        mapRef.current = null
      }
    }
  }, [])

  useEffect(() => {
    console.log(selectedCase)
    if (mapRef.current && Array.isArray(cases)) {
      // Clear existing markers
            // Clear existing markers
      markersRef.current?.forEach((marker) => marker.remove())
      markersRef.current = []
      
      // Add new markers for each case
      cases.forEach((case_) => {
        try {
          const [lat, lng] = case_.location.split(",").map(Number)
          if (!isNaN(lat) && !isNaN(lng)) {
            const marker = L.marker([lat, lng])
              .addTo(mapRef.current!)
              .bindPopup(`Case #${case_.id}<br>${case_.jurisdiction}`)
            markersRef.current?.push(marker)
      
            if (selectedCase && selectedCase.id === case_.id) {
              console.log(`Selected case found: ${case_.id}`)
              marker.openPopup()
              mapRef.current!.setView([lat, lng], 13)
            }
          } else {
            console.error(`Invalid location for case ID ${case_.id}: ${case_.location}`)
          }
        } catch (error) {
          console.error(`Error adding marker for case ID ${case_.id}:`, error)
        }
      })
    }
  }, [cases, selectedCase])
  
  return <div id="map" className="rounded-md" style={{ width: "100%", height: "300px", backgroundColor: "black", position: "absolute", bottom: "0"}}></div>
}

