#include <iostream>
using namespace std;

int main() {
    int n;
    cout << "Enter a number: ";
    cin >> n;

    for (int i = 0; i < n; i++) {
        cout << string(n - i - 1, ' ') << string(2 * i + 1, '*') << endl;
    }

    for (int i = n - 2; i >= 0; i--) {
        cout << string(n - i - 1, ' ') << string(2 * i + 1, '*') << endl;
    }

    return 0;
}