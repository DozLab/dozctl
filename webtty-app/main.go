package main

import (
  "fmt"
  "log"
  "net/http"
  "github.com/gorilla/mux"
  "github.com/yourusername/webtty-app/handler"
)

// Configurable port number
const port = ":8080"

func main() {
  // Initialize a new router
  r := mux.NewRouter()

  // Define routes with error handling
  r.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
    if err := handler.WebSocketHandler(w, r); err != nil {
      log.Printf("Error handling WebSocket request: %v", err)
      http.Error(w, err.Error(), http.StatusInternalServerError)
    }
  })

  // Serve static files from a specific directory
  staticHandler := http.FileServer(http.Dir("./web/static"))
  r.PathPrefix("/static/").Handler(staticHandler)

  // Start the server with logging
  log.Printf("Starting server on %s", port)
  if err := http.ListenAndServe(port, r); err != nil {
    log.Fatal(fmt.Errorf("Failed to start server: %v", err))
  }
}
