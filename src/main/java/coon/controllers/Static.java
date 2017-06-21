package coon.controllers;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.ErrorController;
import org.springframework.boot.context.config.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;


@Controller
public class Static implements ErrorController {

    private static final String ERROR_PATH = "/error";
    private String frontendApplication;


    public Static() {
        try {
            this.frontendApplication = String.join(
                    "\n", Files.readAllLines(Paths.get("./frontend/application.html"))
            );
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    @RequestMapping(value = ERROR_PATH, produces = "text/html")
    public ResponseEntity<String> serve() {
        return new ResponseEntity<>(this.frontendApplication, HttpStatus.OK);
    }

    @Override
    public String getErrorPath() {
        return ERROR_PATH;
    }
}
