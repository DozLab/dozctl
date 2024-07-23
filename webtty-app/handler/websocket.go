package handler

import (
  "encoding/json"
  "fmt"
  "log"
  "net/http"

  "github.com/gorilla/websocket"
)

// Message represents a message structure exchanged over the WebSocket
type Message struct {
  Type string `json:"type"`
  Data string `json:"data"`
}

// WebSocketHandler handles WebSocket requests from clients
func WebSocketHandler(w http.ResponseWriter, r *http.Request) {
  upgrader := websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool {
      // Implement origin check logic if needed (currently allows all)
      return true
    },
  }

  conn, err := upgrader.Upgrade(w, r, nil)
  if err != nil {
    log.Printf("Failed to upgrade to WebSocket: %v", err)
    return
  }
  defer conn.Close()

  for {
    // Read message
    messageType, message, err := conn.ReadMessage()
    if err != nil {
      if websocket.IsCloseError(err, websocket.CloseNormalClosure) {
        log.Println("Client disconnected")
      } else {
        log.Printf("Error reading message: %v", err)
      }
      return
    }

    // Process message based on type
    var msg Message
    if err := json.Unmarshal(message, &msg); err != nil {
      log.Printf("Error decoding message: %v", err)
      continue
    }

    switch msg.Type {
    case "echo":
      // Example: Echo message back to client
      log.Printf("Received echo message: %s", msg.Data)
      if err := conn.WriteMessage(messageType, message); err != nil {
        log.Printf("Error sending echo message: %v", err)
      }
    default:
      log.Printf("Unknown message type: %s", msg.Type)
    }
  }
}
