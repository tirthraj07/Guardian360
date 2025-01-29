const express = require("express");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const xss = require("xss-clean");
const WebSocket = require("ws");

const app = express();
app.use(cors());
app.options("*", cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());
app.use(xss());

app.get("/", (req, res) => {
  res.send("Hello World!");
})

app.post("/receive_sms", (req, res) => {
  // regex check -> Guardian360-{userId}-{}
  console.log(req.body);
  res.json({ message: "SMS received successfully" });
  
});



// Start HTTP server
const server = app.listen(3000, () => {
  console.log("Server is running on port 3000");
});

// WebSocket server
const wss = new WebSocket.Server({ server });

let connectedClients = new Set();
let smsQueue = [];  // In-memory queue for storing undelivered messages

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
    // No clients connected, store in queue
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
