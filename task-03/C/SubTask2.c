#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *in_file, *out_file;
    char *buffer;
    long num_bytes;

    in_file = fopen("input.txt", "r");
    if(in_file == NULL) {
        return 1;
    }

    fseek(in_file, 0L, SEEK_END);
    num_bytes = ftell(in_file);
    fseek(in_file, 0L, SEEK_SET);

    buffer = (char*)calloc(num_bytes, sizeof(char));
    fread(buffer, sizeof(char), num_bytes, in_file);
    fclose(in_file);

    out_file = fopen("output.txt", "w");
    fwrite(buffer, sizeof(char), num_bytes, out_file);
    fclose(out_file);

    free(buffer);
    return 0;
}