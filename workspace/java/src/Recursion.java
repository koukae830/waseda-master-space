import java.util.Scanner;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Recursion {
    public static int getFibonacci(int n) {
        if (n == 0 || n == 1) {
            return 0;
        }
        if (n == 2) {
            return 1;
        }

        int a = 0, b = 0, c = 1; // F0, F1, F2
        for (int i = 3; i <= n; i++) {
            int ret = a + b + c;
            a = b;
            b = c;
            c = ret;
        }
        return c;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int n = scanner.nextInt();
        System.out.println("F" + n + " = " + getFibonacci(n));
    }
}