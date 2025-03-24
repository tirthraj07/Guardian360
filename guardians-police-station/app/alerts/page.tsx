import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

const alerts = [
  { id: 1, title: "Emergency Alert", description: "Suspicious activity reported", severity: "high" },
  { id: 2, title: "Weather Warning", description: "Heavy rainfall expected", severity: "medium" },
  // Add more alerts as needed
]

export default function Alerts() {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Alerts</h1>
      {alerts.map((alert) => (
        <Card key={alert.id}>
          <CardHeader>
            <CardTitle className="flex items-center justify-between">
              {alert.title}
              <Badge variant={alert.severity === "high" ? "destructive" : "default"}>{alert.severity}</Badge>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p>{alert.description}</p>
          </CardContent>
        </Card>
      ))}
    </div>
  )
}

