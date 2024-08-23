package main

import (
    "io/ioutil"
    "log"
)

func main() {
    data, err := ioutil.ReadFile("input.txt")
    if err != nil {
        log.Fatal(err)
    }

    err = ioutil.WriteFile("output.txt", data, 0644)
    if err != nil {
        log.Fatal(err)
    }
}