package com.example.slpp_project.controller;

import org.springframework.web.bind.annotation.*;

import com.example.slpp_project.service.PetitionService;

import org.springframework.beans.factory.annotation.Autowired;

@RestController
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private PetitionService petitionService;

    @DeleteMapping("/delete/{id}")
    public String deletePetition(@PathVariable Long id) {
        return petitionService.deletePetition(id);
    }
}