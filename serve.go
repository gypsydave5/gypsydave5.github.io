package main

import (
	"log"
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("site"))
	http.Handle("/", fs)

	log.Println("Serving site on port 8000 (http://localhost:3000")
	log.Fatal(http.ListenAndServe(":8000", nil))
}
