package coon;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;


@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        try {
            Process p = Runtime.getRuntime().exec("node ./frontend/start.js");

            new Thread(() -> {
                BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
                BufferedReader error = new BufferedReader(new InputStreamReader(p.getErrorStream()));
                String line;

                try {
                    while ((line = input.readLine()) != null) {
                        System.out.println(line);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }

                boolean hasErrors = false;

                try {
                    while ((line = error.readLine()) != null) {
                        System.err.println(line);
                        hasErrors = true;
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }

                if (hasErrors) {
                    Runtime.getRuntime().halt(-1);
                }
            }).start();

            p.waitFor();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();

            return;
        }

        SpringApplication.run(Application.class, args);
    }

}
