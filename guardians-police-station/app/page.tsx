"use client"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

import dynamic from "next/dynamic";
const PunePoliceMapHome = dynamic(
  () => import("../components/PunePoliceMapHome"),
  { ssr: false }
);
export default function Dashboard() {
  return (
    <div className="space-y-4 dark bg-black">
      <h1 className="text-2xl font-bold">Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card>
          <CardHeader>
            <CardTitle>New Cases Summary</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold">5</p>
            <p className="text-sm text-gray-500">New cases in the last 24 hours</p>
          </CardContent>
        </Card>
        <Card className="md:col-span-2">
          <CardHeader>
            <CardTitle>Pune Police Jurisdictions</CardTitle>
          </CardHeader>
          <CardContent>
            <PunePoliceMapHome />
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

