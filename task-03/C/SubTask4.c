#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *infile, *outfile;
    int n;

    infile = fopen("input.txt", "r");
    if (infile == NULL) {
        return 1;
    }
    fscanf(infile, "%d", &n);
    fclose(infile);

    outfile = fopen("output.txt", "w");
    if (outfile == NULL) {
        return 1;
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n - i - 1; j++) fprintf(outfile, " ");
        for (int j = 0; j < 2 * i + 1; j++) fprintf(outfile, "*");
        fprintf(outfile, "\n");
    }
    for (int i = n - 2; i >= 0; i--) {
        for (int j = 0; j < n - i - 1; j++) fprintf(outfile, " ");
        for (int j = 0; j < 2 * i + 1; j++) fprintf(outfile, "*");
        fprintf(outfile, "\n");
    }

    fclose(outfile);
    return 0;
}
