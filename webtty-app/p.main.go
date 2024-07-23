// package main

// import (
//     "log"
//     "net/http"
//     "github.com/gorilla/mux"
//     "github.com/dozman99/dexter-lab/handler"
// )

// func main() {
//     // Initialize a new router
//     r := mux.NewRouter()

//     // Define routes
//     r.HandleFunc("/ws", handler.WebSocketHandler)

//     // Serve static files
//     r.PathPrefix("/").Handler(http.FileServer(http.Dir("./web/")))

//     // Start the server
//     log.Println("Starting server on :8080")
//     if err := http.ListenAndServe(":8080", r); err != nil {
//         log.Fatalf("Failed to start server: %v", err)
//     }
// }