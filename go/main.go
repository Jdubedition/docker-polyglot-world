package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strings"
)

func handler(w http.ResponseWriter, r *http.Request) {
	p := strings.Split(r.URL.Path, "/")[1:]
	if p[0] != "" {
		http.Error(w, "Not Found", http.StatusNotFound)
		return
	}

	name, err := os.Hostname()
	if err != nil {
		panic(err)
	}

	message := struct {
		Hello string `json:"hello"`
		From  string `json:"from"`
	}{
		"World",
		name,
	}

	body, err := json.Marshal(message)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(body)
	log.Println("INFO: " + r.Host + " " + r.Method)
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
