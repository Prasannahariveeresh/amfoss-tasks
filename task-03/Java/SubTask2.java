import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FileCopy {
    public static void main(String[] args) throws IOException {
        String data = new String(Files.readAllBytes(Paths.get("input.txt")));
        Files.write(Paths.get("output.txt"), data.getBytes());
    }
}