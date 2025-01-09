package com.example.slpp_project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RootController {

    @GetMapping("/")
    public String redirectToAuthLogin() {
        return "redirect:/auth/login";
    }
}