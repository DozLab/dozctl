// package handler

// import (
//     "log"
//     "net/http"
//     "github.com/gorilla/websocket"
// )

// // WebSocketHandler handles WebSocket requests from clients
// func WebSocketHandler(w http.ResponseWriter, r *http.Request) {
//     upgrader := websocket.Upgrader{
//         CheckOrigin: func(r *http.Request) bool {
//             return true
//         },
//     }

//     conn, err := upgrader.Upgrade(w, r, nil)
//     if err != nil {
//         log.Printf("Failed to upgrade to WebSocket: %v", err)
//         return
//     }
//     defer conn.Close()

//     for {
//         messageType, p, err := conn.ReadMessage()
//         if err != nil {
//             log.Printf("Error reading message: %v", err)
//             return
//         }

//         if err := conn.WriteMessage(messageType, p); err != nil {
//             log.Printf("Error writing message: %v", err)
//             return
//         }
//     }
// }