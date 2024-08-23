#include <iostream>
#include <fstream>
using namespace std;

int main() {
    ifstream infile("input.txt");
    ofstream outfile("output.txt");

    int n;
    infile >> n;

    for (int i = 0; i < n; i++) {
        outfile << string(n - i - 1, ' ') << string(2 * i + 1, '*') << endl;
    }
    for (int i = n - 2; i >= 0; i--) {
        outfile << string(n - i - 1, ' ') << string(2 * i + 1, '*') << endl;
    }

    return 0;
}
