package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

func TestHandler(t *testing.T) {
	// Create a request to pass to our handler.
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	// We create a ResponseRecorder (which satisfies http.ResponseWriter) to record the response.
	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(handler)

	// Our handlers satisfy http.Handler, so we can call their ServeHTTP method
	// directly and pass in our Request and ResponseRecorder.
	handler.ServeHTTP(rr, req)

	// Check the status code is what we expect.
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
	}

	// Check the response body is what we expect.
	var message struct {
		Language       string `json:"language"`
		Greeting       string `json:"greeting"`
		From           string `json:"from"`
		Implementation string `json:"implementation"`
	}
	if err := json.Unmarshal(rr.Body.Bytes(), &message); err != nil {
		t.Fatal(err)
	}

	if message.Language == "" {
		t.Errorf("missing language in response")
	}
	if message.Greeting == "" {
		t.Errorf("missing greeting in response")
	}
	hostname, _ := os.Hostname()
	if message.From != hostname {
		t.Errorf("wrong hostname in response: got %v want %v", message.From, hostname)
	}
	if message.Implementation != "Go" {
		t.Errorf("wrong implementation in response: got %v want %v", message.Implementation, "Go")
	}
}

func TestNotFound(t *testing.T) {
	req, err := http.NewRequest("GET", "/notfound", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(handler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusNotFound {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusNotFound)
	}
}

func TestInternalServerError(t *testing.T) {
	// Override os.Hostname to return an error
	osHostname = func() (string, error) {
		return "", fmt.Errorf("error")
	}
	defer func() { osHostname = os.Hostname }()

	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(handler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusInternalServerError {
		fmt.Print(rr.Body.String())
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusInternalServerError)
	}
}

func TestRandomGreeting(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(handler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	var message struct {
		Language string `json:"language"`
		Greeting string `json:"greeting"`
		From     string `json:"from"`
	}

	json.Unmarshal(rr.Body.Bytes(), &message)

	hostname, _ := os.Hostname()
	if message.From != hostname {
		t.Errorf("handler returned unexpected hostname: got %v want %v",
			message.From, hostname)
	}

	// Check that the greeting returned is in the list of languages
	var languages []struct {
		Language string `json:"language"`
		Greeting string `json:"greeting"`
	}
	file, _ := os.Open("../hello-world.json")
	decoder := json.NewDecoder(file)
	decoder.Decode(&languages)

	var found bool
	for _, lang := range languages {
		if lang.Greeting == message.Greeting {
			found = true
			break
		}
	}
	if !found {
		t.Errorf("handler returned unexpected greeting: got %v want one of %v",
			message.Greeting, languages)
	}
}
