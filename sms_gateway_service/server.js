const express = require("express");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const xss = require("xss-clean");
const WebSocket = require("ws");
// const fetch = require('node-fetch');

const app = express();
app.use(cors());
app.options("*", cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());
app.use(xss());


require('dotenv').config();

PORT = process.env.PORT || 3000
console.log(`PORT ${PORT}`)

SOS_SERVICE_URL = process.env.SOS_SERVICE_URL
console.log(`SOS_SERVICE_URL : ${SOS_SERVICE_URL}`)

if(!SOS_SERVICE_URL){
  console.error("SOS_SERVICE_URL not defined in environment variables");
  process.exit(1);
}

app.get("/", (req, res) => {
  res.send("SMS Gateway Service");
})

app.post("/sos", (req, res)=>{

  console.log("==== START OF SOS SERVICE ====\n\n\n")

  const headers = req.headers;
  console.log(headers)

  const body = req.body;
  console.log(body);

  console.log("==== END OF SOS Service ===\n\n\n")

  return res.status(200).json({"message":"SOS Service Initiated"});
})

app.post("/receive_sms", async (req, res) => {
  console.log(req.body);
  // { message_body: 'INSERT MESSAGE HERE', message_sender: '+91<phone-no>' }
  const { message_body, message_sender } = req.body

  if (!message_body || !message_sender){
    console.error("Request body does not contain message_body and message_sender")
    return res.status(400).json({ message: "Error: POST /receive_sms requires { message_sender: string, message_body: string }" })
  }

  const regex = /^Guardian360-(\d+)-(\{[\s\S]*\})$/;

  const match = message_body.match(regex);

  /*
    Guardian360-{
        "LAT": "18.5204",
        "LONG": "73.8567",
        "TYPE": "SOS",
        "BATTERY": "85%"
    }
  */

  if (match) {
    try {
      let jsonString = match[2].trim();
      jsonString = jsonString.replace(/([{,]\s*)'([^']+)'(?=\s*[:}])/g, '$1"$2"');

      jsonString = jsonString.replace(/'/g, '"');
      const jsonData = JSON.parse(jsonString);

      const userID = parseInt(match[1], 10);
      const latitude = parseFloat(jsonData.LAT);
      const longitude = parseFloat(jsonData.LONG);
      const alertType = jsonData.TYPE;
      const battery = jsonData.BATTERY;
      const timestamp = new Date().toISOString();

      console.log("Parsed Data:", { userID, latitude, longitude, alertType, battery });

      if(alertType == 'SOS'){
        console.log("Calling SOS Service..")
        const headers = {
          "Content-Type":"application/json",
          "x-Token":"SMS"
        }
        const body = {
          "latitude" : latitude,
          "longitude": longitude,
          "timestamp": timestamp
        }
        
        const response = await fetch(`${SOS_SERVICE_URL}/sos`, {
          method: "POST",
          headers: headers,
          body: JSON.stringify(body),
        });
        
        if (!response.ok) {
          console.error("Failed to call SOS Service:", response.statusText);
          return res.status(500).json({ error: "Failed to call SOS Service" });
        }
        
        const result = await response.json();
        console.log(result);
      }
      
      return res.json({ message: "Parsed and stored successfully", data: { latitude, longitude, alertType, battery } });
    } catch (error) {
      console.error("JSON Parsing Error:", error);
      console.error("Received JSON ", match[1])
      return res.status(400).json({ error: "Invalid JSON format}" });
    }
  } else {
    console.error("SMS received but format did not match")
    return res.status(400).json({ message: "SMS received but format did not match" });
  }

});


// Start HTTP server
const server = app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

// WebSocket server
const wss = new WebSocket.Server({ server });

let connectedClients = new Set();
// In-memory queue for storing undelivered messages
let smsQueue = [];  

wss.on("connection", (ws) => {
  console.log("New WebSocket connection established");
  connectedClients.add(ws);

  // Send all queued messages to the new client
  while (smsQueue.length > 0) {
    const smsData = smsQueue.shift(); // Remove message from queue
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify(smsData));
      console.log("Sent queued SMS:", smsData);
    }
  }

  ws.on("close", () => {
    console.log("WebSocket connection closed");
    connectedClients.delete(ws);
  });

  ws.on("error", (err) => {
    console.error("WebSocket error:", err);
  });
});

// Endpoint to receive SMS and forward/store it
app.post("/queue_sms", (req, res) => {
  const smsData = req.body;
  console.log("Received SMS:", smsData);

  if (connectedClients.size === 0) {
    smsQueue.push(smsData);
    console.log("No active WebSocket clients. SMS stored in queue.");
  } else {
    // Clients are connected, send the SMS immediately
    connectedClients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(smsData));
      }
    });
  }

  res.json({ message: "SMS received and processed" });
});
