#include <iostream>
#include <fstream>
#include <string>

int main() {
    std::ifstream in_file("input.txt");
    std::ofstream out_file("output.txt");

    std::string data((std::istreambuf_iterator<char>(in_file)), std::istreambuf_iterator<char>());
    out_file << data;

    return 0;
}