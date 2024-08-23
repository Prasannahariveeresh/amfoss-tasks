package main

import (
    "io/ioutil"
    "log"
    "strconv"
    "strings"
)

func main() {
    data, err := ioutil.ReadFile("input.txt")
    if err != nil {
        log.Fatal(err)
    }

    n, err := strconv.Atoi(strings.TrimSpace(string(data)))
    if err != nil {
        log.Fatal(err)
    }

    var output strings.Builder

    for i := 0; i < n; i++ {
        output.WriteString(strings.Repeat(" ", n-i-1) + strings.Repeat("*", 2*i+1) + "\n")
    }
    for i := n - 2; i >= 0; i-- {
        output.WriteString(strings.Repeat(" ", n-i-1) + strings.Repeat("*", 2*i+1) + "\n")
    }

    err = ioutil.WriteFile("output.txt", []byte(output.String()), 0644)
    if err != nil {
        log.Fatal(err)
    }
}
