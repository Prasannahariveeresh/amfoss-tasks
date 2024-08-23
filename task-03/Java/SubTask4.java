import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class DiamondPattern {
    public static void main(String[] args) throws IOException {
        List<String> lines = Files.readAllLines(Paths.get("input.txt"));
        int n = Integer.parseInt(lines.get(0).trim());
        StringBuilder output = new StringBuilder();

        for (int i = 0; i < n; i++) {
            output.append(" ".repeat(n - i - 1)).append("*".repeat(2 * i + 1)).append("\n");
        }

        for (int i = n - 2; i >= 0; i--) {
            output.append(" ".repeat(n - i - 1)).append("*".repeat(2 * i + 1)).append("\n");
        }

        Files.write(Paths.get("output.txt"), output.toString().getBytes());
    }
}
