"use client";
/* eslint-disable @typescript-eslint/no-explicit-any */

import { useEffect, useState } from "react";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from "recharts";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

type Case = {
  _id: string;
  userID: number;
  typeName: string;
  subtypeName: string;
  description: string;
  latitude: number;
  longitude: number;
  place_name: string;
  ai_generated: boolean;
  inserted_at: string;
};

// Define month names.
const MONTH_NAMES = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
];

// Helper function to compute monthly counts.
const getMonthlyData = (cases: Case[]) => {
  const data: { [key: number]: number } = {};
  cases.forEach((case_) => {
    const month = new Date(case_.inserted_at).getMonth() + 1;
    data[month] = (data[month] || 0) + 1;
  });
  return Object.entries(data)
    .map(([month, count]) => ({
      month: Number(month),
      count,
    }))
    .sort((a, b) => a.month - b.month);
};

// Helper function to create data for AI generated pie chart.
const getAIPieData = (cases: Case[]) => {
  const trueCount = cases.filter((c) => c.ai_generated).length;
  const falseCount = cases.filter((c) => !c.ai_generated).length;
  return [
    { name: "AI Generated True", value: trueCount },
    { name: "AI Generated False", value: falseCount },
  ];
};

// Helper function to compute counts by subtype.
const getSubtypeData = (cases: Case[]) => {
  const data: { [key: string]: number } = {};
  cases.forEach((case_) => {
    const subtype = case_.subtypeName || "Unknown";
    data[subtype] = (data[subtype] || 0) + 1;
  });
  return Object.entries(data).map(([name, count]) => ({ name, count }));
};

// Define color arrays for the charts.
const PIE_COLORS = ['#0088FE', '#FF8042']; // Two distinct colors for the pie chart.
const SUBTYPE_COLORS = ['#FFBB28', '#FF8042', '#00C49F', '#0088FE', '#ff7300', '#82ca9d'];

export default function Analytics() {
  const [cases, setCases] = useState<Case[]>([]);

  // Fetch initial cases on mount.
  useEffect(() => {
    async function fetchInitialCases() {
      const response = await fetch("/api/mongo");
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      const data = await response.json();
      const fetchedCases: Case[] = data.map((doc: any) => ({
        _id: doc._id.toString(),
        userID: doc.userID,
        typeName: doc.typeName,
        subtypeName: doc.subtypeName,
        description: doc.description || doc.place_name || "No description",
        latitude: doc.latitude,
        longitude: doc.longitude,
        place_name: doc.place_name,
        ai_generated: doc.ai_generated,
        inserted_at: doc.inserted_at,
      }));
      setCases(fetchedCases);
    }
    fetchInitialCases();
  }, []);

  // Prepare data for the charts.
  const monthlyData = getMonthlyData(cases);
  const aiPieData = getAIPieData(cases);
  const subtypeData = getSubtypeData(cases);

  return (
    <div className="relative text-black bg-background">
      <div style={{ height: "100vh", overflowY: "auto", padding: "1rem" }}>
        <h1 className="text-2xl font-bold mb-4 text-white">Analytics</h1>

        {/* Monthly Cases Line Chart */}
        <Card className="mb-4">
          <CardHeader>
            <CardTitle>Monthly Cases</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart
                data={monthlyData}
                margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
              >
                <CartesianGrid strokeDasharray="3 3" stroke="#ccc" />
                <XAxis
                  dataKey="month"
                  tickFormatter={(month: number) => MONTH_NAMES[month - 1]}
                  stroke="#fff"
                />
                <YAxis stroke="#fff" />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "#f5f5f5",
                    border: "1px solid #ccc",
                  }}
                />
                <Legend />
                <Line
                  type="monotone"
                  dataKey="count"
                  stroke="#ff7300"  // Bright orange for the line.
                  strokeWidth={3}
                  activeDot={{ r: 8, stroke: '#ff7300', strokeWidth: 2 }}
                  dot={{ fill: "#ff7300" }}
                />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* AI Generated Cases Pie Chart */}
        <Card className="mb-4">
          <CardHeader>
            <CardTitle>AI Generated Cases</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={aiPieData}
                  dataKey="value"
                  nameKey="name"
                  cx="50%"
                  cy="50%"
                  outerRadius={80}
                  label
                >
                  {aiPieData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={PIE_COLORS[index % PIE_COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip
                  contentStyle={{
                    backgroundColor: "#f5f5f5",
                    border: "1px solid #ccc",
                  }}
                />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Subtype Name Bar Chart */}
        <Card className="mb-4">
          <CardHeader>
            <CardTitle>Subtype Cases</CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart
                data={subtypeData}
                margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
              >
                <CartesianGrid strokeDasharray="3 3" stroke="#fff" />
                <XAxis dataKey="name" stroke="#fff" />
                <YAxis stroke="#333" />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "#f5f5f5",
                    border: "1px solid #ccc",
                  }}
                />
                <Legend />
                <Bar dataKey="count">
                  {subtypeData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={SUBTYPE_COLORS[index % SUBTYPE_COLORS.length]} />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
