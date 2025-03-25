#include <ArduinoHttpClient.h>
#include <ESP8266WiFi.h>

const char *ssid = "Tirthraj Mahajan";  
const char *password = "tirthraj07";

WiFiClient wifiClient;
const char *server = "134.209.154.89";  
const int port = 8005;
const char *postPath = "/api/sos";  

HttpClient http = HttpClient(wifiClient, server, port);

const int pushbutton = 13;
const int led = 33;
int button_id = 1;  // Unique button identifier

bool lastButtonState = HIGH;  // Track previous button state

void setup() {
    Serial.begin(115200);
    Serial.println("\n\nStarting ESP8266...");
    pinMode(pushbutton, INPUT_PULLUP);
    pinMode(led, OUTPUT);

    Serial.print("Connecting to WiFi: ");
    Serial.println(ssid);

    WiFi.begin(ssid, password);
    int attempt = 0;
    while (WiFi.status() != WL_CONNECTED && attempt < 20) { // Try for 10 seconds
        delay(500);
        Serial.print(".");
        attempt++;
    }

    if (WiFi.status() == WL_CONNECTED) {
        Serial.println("\nWiFi connected!");
        Serial.print("IP Address: ");
        Serial.println(WiFi.localIP());
    } else {
        Serial.println("\nFailed to connect to WiFi! Restarting...");
        ESP.restart();
    }
}

void loop() {
    bool currentButtonState = digitalRead(pushbutton);

    if (currentButtonState == LOW && lastButtonState == HIGH) {
        Serial.println("Button Press Detected");
        sendButtonPress();
    }

    lastButtonState = currentButtonState;
    delay(50);  // Debounce delay
}

void sendButtonPress() {
    Serial.println("Sending Button Press...");

    String jsonPayload = "{\"button_mac\": \"41b147ca-6d75-4617-8c2a-1e86c3d88723\"}";
    
    Serial.println("JSON Payload: " + jsonPayload);  // Print JSON before sending

    Serial.print("Sending POST request to: http://");
    Serial.print(server);
    Serial.print(":");
    Serial.print(port);
    Serial.println(postPath);

    http.beginRequest();
    http.post(postPath);
    http.sendHeader("Content-Type", "application/json");
    http.sendHeader("x-Token", "WIFI_BUTTON");  // Custom header
    http.sendHeader("Content-Length", String(jsonPayload.length())); // Ensure proper length
    http.beginBody();
    http.print(jsonPayload);
    http.endRequest();

    int statusCode = http.responseStatusCode();
    String response = http.responseBody();

    Serial.print("Press Response Code: ");
    Serial.println(statusCode);
    Serial.print("Press Response: ");
    Serial.println(response);

    if (statusCode != 200) {
        Serial.println("Error: Failed to send POST request");
    }
}