package main

import (
	"encoding/json"
	"log"
	"math/rand"
	"net/http"
	"os"
	"strings"
)

// Override for testing
var osHostname = os.Hostname

func getHostname() (string, error) {
	host, err := osHostname()
	if err != nil {
		return "", err
	}
	return host, nil
}

func handler(w http.ResponseWriter, r *http.Request) {
	p := strings.Split(r.URL.Path, "/")[1:]
	if p[0] != "" {
		http.Error(w, "Not Found", http.StatusNotFound)
		return
	}
	var languages []struct {
		Language string `json:"language"`
		Greeting string `json:"greeting"`
	}
	file, err := os.Open("../hello-world.json")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	decoder := json.NewDecoder(file)
	err = decoder.Decode(&languages)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	random_language := languages[rand.Intn(len(languages))]
	name, err := getHostname()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	message := struct {
		Language       string `json:"language"`
		Greeting       string `json:"greeting"`
		From           string `json:"from"`
		Implementation string `json:"implementation"`
	}{
		random_language.Language,
		random_language.Greeting,
		name,
		"Go",
	}
	body, err := json.Marshal(message)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(body)
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
