package main

import (
	"log"
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("site"))
	http.Handle("/", fs)
	port := ":3333"

	log.Printf("Serving site on port %[1]s (http://localhost%[1]s)\n", port)
	log.Fatal(http.ListenAndServe(port, nil))
}
