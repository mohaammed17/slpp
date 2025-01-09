package com.example.slpp_project.controller;

import com.example.slpp_project.model.Petition;
import com.example.slpp_project.service.PetitionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class CommitteeController {

    @Autowired
    private PetitionService petitionService;

    @GetMapping("/dashboard")
    public String showCommitteeDashboard(Model model) {
        List<Petition> petitions = petitionService.listPetitions();
        System.out.println("Number of petitions: " + petitions.size());
        model.addAttribute("petitions", petitions);
        return "committeeDashboard";
    }

    @PostMapping("/{petitionId}/respond")
    public String respondToPetition(@PathVariable Long petitionId, @RequestParam String response, Model model) {
        Petition petition = petitionService.findById(petitionId);
        if (petition != null && "OPEN".equalsIgnoreCase(petition.getStatus())) {
            petition.setResponseText(response);
            petition.setStatus("CLOSED");
            petitionService.savePetition(petition);
            // Optionally, add a success message
            model.addAttribute("message", "Petition responded to and closed successfully.");
        } else {
            // Optionally, handle the case where petition is not found or already closed
            model.addAttribute("error", "Petition not found or already closed.");
        }
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/{petitionId}/status")
    public String updatePetitionStatus(@PathVariable Long petitionId, @RequestParam String status, Model model) {
        petitionService.updatePetitionStatus(petitionId, status);
        return "redirect:/admin/dashboard";
    }

    @GetMapping("/{petitionId}/delete")
    public String deletePetition(@PathVariable Long petitionId, Model model) {
        petitionService.deletePetition(petitionId);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/dashboard/action")
    public String handleDashboardAction(
            @RequestParam Long petitionId,
            @RequestParam String action,
            @RequestParam(required = false) String response,
            @RequestParam(required = false) String status,
            Model model) {

        if ("respond".equalsIgnoreCase(action)) {
            Petition petition = petitionService.findById(petitionId);
            if (petition != null && "OPEN".equalsIgnoreCase(petition.getStatus())) {
                petition.setResponseText(response);
                petition.setStatus("CLOSED");
                petitionService.savePetition(petition);
                model.addAttribute("message", "Petition responded to and closed successfully.");
            } else {
                model.addAttribute("error", "Petition not found or already closed.");
            }
        } else if ("updateStatus".equalsIgnoreCase(action)) {
            Petition petition = petitionService.findById(petitionId);
            if (petition != null) {
                petition.setStatus(status.toUpperCase());
                petitionService.savePetition(petition);
                model.addAttribute("message", "Petition status updated successfully.");
            } else {
                model.addAttribute("error", "Petition not found.");
            }
        } else {
            model.addAttribute("error", "Invalid action selected.");
        }

        return "redirect:/admin/dashboard";
    }
}
