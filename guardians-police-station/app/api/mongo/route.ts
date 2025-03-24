// pages/api/cases.ts
/* eslint-disable @typescript-eslint/no-explicit-any */

import { NextResponse } from "next/server";
import clientPromise from "@/lib/mongo";

export async function GET() {
  try {
    const client = await clientPromise;
    const db = client.db("guardian360db"); // Replace with your actual DB name
    // Adjust the collection name if needed
    const cases = await db.collection("incident_reports").find({}).toArray();
    return NextResponse.json(cases, { status: 200 });
  } catch (error: any) {
    console.error("Error fetching cases:", error);
    return NextResponse.json({ message: "Error fetching cases", error: error.message }, { status: 500 });
  }
}
