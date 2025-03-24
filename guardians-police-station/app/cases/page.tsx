"use client";
/* eslint-disable @typescript-eslint/no-explicit-any */

import { useEffect, useState, useRef } from "react";

import dynamic from "next/dynamic";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Button } from "@/components/ui/button";

// Import the map component (which will use the selectedCase prop to focus on the location)
const PunePoliceMap = dynamic(
  () => import("../../components/PunePoliceMap"),
  { ssr: false }
);

type Case = {
  id: string;
  date: string;
  description: string;
  location: string;
  status: "Investigating" | "Resolved" | "Pending";
  jurisdiction: string;
  officerInCharge: string;
  witnesses: string[];
  evidence: string[];
  notes: string;
};

const jurisdictions = ["All", "Pune City", "Pune Rural"];



export default function Cases() {
  const [cases, setCases] = useState<Case[]>([]);
  const [selectedJurisdiction, setSelectedJurisdiction] = useState("All");
  const [expandedCases, setExpandedCases] = useState<Set<string>>(new Set());
  const [selectedCase, setSelectedCase] = useState<Case | null>(null);
  const [popupCase, setPopupCase] = useState<Case | null>(null);

  // A ref to keep track of known case IDs to avoid duplicate alerts.
  const knownCaseIds = useRef<Set<string>>(new Set());

  // Helper function to parse the inserted_at field.
  const parseInsertedAt = (value: any): string => {
    let parsedDate = new Date(value);
    if (!isNaN(parsedDate.getTime())) {
      return parsedDate.toISOString().split("T")[0];
    }
    if (value && typeof value === "object" && "t" in value) {
      parsedDate = new Date(value.t * 1000);
      if (!isNaN(parsedDate.getTime())) {
        return parsedDate.toISOString().split("T")[0];
      }
    }
    return "Invalid Date";
  };

  // Fetch initial cases on mount.
  useEffect(() => {
    async function fetchInitialCases() {
      try {
        const response = await fetch("/api/mongo");
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        const data = await response.json();
        const fetchedCases: Case[] = data.map((doc: any) => ({
          id: doc._id.toString(),
          date: parseInsertedAt(doc.inserted_at),
          description:
            typeof doc.description === "string"
              ? doc.description
              : doc.place_name || "No description",
          location: `${doc.latitude}, ${doc.longitude}`,
          status: "Investigating",
          jurisdiction: "Pune City",
          officerInCharge: "Unknown",
          witnesses: [],
          evidence: [],
          notes: "",
        }));
        setCases(fetchedCases);
        // Populate the known IDs.
        const ids = new Set<string>();
        fetchedCases.forEach((c) => ids.add(c.id));
        knownCaseIds.current = ids;
      } catch (error) {
        console.error("Error fetching initial cases:", error);
      }
    }
    fetchInitialCases();
  }, []);

  // Poll for new cases every 5 seconds.
  useEffect(() => {
    const intervalId = setInterval(async () => {
      try {
        const response = await fetch("/api/mongo");
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        const data = await response.json();
        const fetchedCases: Case[] = data.map((doc: any) => ({
          id: doc._id.toString(),
          date: parseInsertedAt(doc.inserted_at),
          description:
            typeof doc.description === "string"
              ? doc.description
              : doc.place_name || "No description",
          location: `${doc.latitude}, ${doc.longitude}`,
          status: "Investigating",
          jurisdiction: "Pune City",
          officerInCharge: "Unknown",
          witnesses: [],
          evidence: [],
          notes: "",
        }));
        // Identify new cases by filtering out known case IDs.
        const newCases = fetchedCases.filter(
          (c) => !knownCaseIds.current.has(c.id)
        );
        if (newCases.length > 0) {
          // Play alert sound. Ensure /public/alert.mp3 exists.
          const alertAudio = new Audio("/danger.mp3");
          alertAudio.play().catch((err) =>
            console.error("Audio play error:", err)
          );
          // Show the popup alert and set the selected case so the map focuses on it.
          setPopupCase(newCases[0]);
          setSelectedCase(newCases[0]);
          // Update the cases list and known IDs.
          setCases((prev) => [...prev, ...newCases]);
          newCases.forEach((c) => knownCaseIds.current.add(c.id));
        }
      } catch (error) {
        console.error("Error polling for new cases:", error);
      }
    }, 3000); // Polling interval (adjust if needed)
    return () => clearInterval(intervalId);
  }, []);

  // Filter cases based on the selected jurisdiction.
  const filteredCases =
    selectedJurisdiction === "All"
      ? cases
      : cases.filter((case_) => case_.jurisdiction === selectedJurisdiction);



  const toggleExpansion = (caseId: string) => {
    setExpandedCases((prev) => {
      const next = new Set(prev);
      if (next.has(caseId)) {
        next.delete(caseId);
      } else {
        next.add(caseId);
      }
      return next;
    });
  };

  const handleCaseSelect = (case_: Case) => {
    console.log(case_);
    setSelectedCase(case_);
  };

  const closePopup = () => setPopupCase(null);

  return (
    <div className="relative text-black bg-background">
      <div style={{ height: "100vh", overflowY: "auto", padding: "1rem" }}>
        <h1 className="text-2xl font-bold mb-4">Cases</h1>
        {filteredCases.map((case_) => (
          <Card
            key={case_.id}
            onClick={() => handleCaseSelect(case_)}
            className="cursor-pointer hover:shadow-md transition-shadow mb-4"
          >
            <CardHeader>
              <CardTitle>Case #{case_.id}</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              <p>
                <strong>Date:</strong> {case_.date}
              </p>
              <p>
                <strong>Description:</strong> {case_.description}
              </p>
              <p>
                <strong>Location:</strong> {case_.location}
              </p>
              <p>
                <strong>Jurisdiction:</strong> {case_.jurisdiction}
              </p>
              <div className="flex items-center justify-between">
                <Badge
                  variant={
                    case_.status === "Resolved" ? "secondary" : "default"
                  }
                >
                  {case_.status}
                </Badge>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={(e) => {
                    e.stopPropagation();
                    toggleExpansion(case_.id);
                  }}
                  className="text-blue-600 hover:bg-blue-50"
                >
                  {expandedCases.has(case_.id) ? "Show Less" : "Show More"}
                </Button>
              </div>
              {expandedCases.has(case_.id) && (
                <div className="mt-4 space-y-3 border-t pt-4">
                  <p>
                    <strong>Officer in Charge:</strong>{" "}
                    {case_.officerInCharge}
                  </p>
                  <div>
                    <strong>Witnesses:</strong>
                    <ul className="list-disc pl-6 mt-1">
                      {case_.witnesses.map((witness, index) => (
                        <li key={index}>{witness}</li>
                      ))}
                    </ul>
                  </div>
                  <div>
                    <strong>Evidence:</strong>
                    <ul className="list-disc pl-6 mt-1">
                      {case_.evidence.map((item, index) => (
                        <li key={index}>{item}</li>
                      ))}
                    </ul>
                  </div>
                  <p className="bg-yellow-50 p-3 rounded-md">
                    <strong>Investigation Notes:</strong>
                    <br />
                    {case_.notes}
                  </p>
                </div>
              )}
            </CardContent>
          </Card>
        ))}

       

        <Select onValueChange={setSelectedJurisdiction}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Select Jurisdiction" />
          </SelectTrigger>
          <SelectContent>
            {jurisdictions.map((jurisdiction) => (
              <SelectItem key={jurisdiction} value={jurisdiction}>
                {jurisdiction}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* The map will display markers for all cases, and center on selectedCase */}
      <PunePoliceMap cases={filteredCases} selectedCase={selectedCase} />

      {/* Red blinking alert with sound for a new case */}
      {popupCase && (
        <div className="fixed inset-0 flex items-center justify-center z-50">
          <div className="bg-red-600 text-white p-6 rounded-md shadow-md max-w-md w-full animate-pulse">
            <h2 className="text-2xl font-bold mb-4">New Case Received!</h2>
            <p>
              <strong>ID:</strong> {popupCase.id}
            </p>
            <p>
              <strong>Date:</strong> {popupCase.date}
            </p>
            <p>
              <strong>Description:</strong> {popupCase.description}
            </p>
            <p>
              <strong>Location:</strong> {popupCase.location}
            </p>
            <button
              className="mt-4 px-4 py-2 bg-black text-white rounded"
              onClick={closePopup}
            >
              Dismiss
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
