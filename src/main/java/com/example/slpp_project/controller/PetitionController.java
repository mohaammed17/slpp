package com.example.slpp_project.controller;

import java.util.List;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.slpp_project.service.PetitionService;
import com.example.slpp_project.service.SignatureService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.example.slpp_project.model.Petition;
import com.example.slpp_project.model.User;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/petition")
public class PetitionController {

    @Autowired
    private PetitionService petitionService;

    @Autowired
    private SignatureService signatureService;

    @GetMapping("/create")
    public String showCreatePetitionForm() {
        return "createPetition";
    }

    @PostMapping("/create")
    public String createPetition(Petition petition, HttpSession session) {
        // Retrieve the logged-in user from the session
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            // Redirect to login if no user is found in the session
            return "redirect:/auth/login";
        }

        // Set the createdBy field
        petition.setCreatedBy(currentUser);

        // Save the petition
        petitionService.createPetition(petition);
        return "redirect:/dashboard";
    }

    @GetMapping("/list")
    public List<Petition> listPetitions() {
        return petitionService.listPetitions();
    }

    @Transactional
    @PostMapping("/delete/{id}")
    public String deletePetition(@PathVariable("id") Long id, HttpSession session) {
        // Retrieve the logged-in user from the session
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            // Redirect to login if no user is found in the session
            return "redirect:/auth/login";
        }

        // Ensure the current user is allowed to delete the petition (optional)
        Petition petition = petitionService.getPetitionById(id);
        if (petition != null && petition.getCreatedBy().getUserId().equals(currentUser.getUserId())) {
            petitionService.deletePetition(id);
        }

        return "redirect:/dashboard";
    }

    @GetMapping("/{id}")
    public String viewPetitionDetails(@PathVariable("id") Long id, Model model, HttpSession session) {
        // Retrieve the logged-in user (optional, for authorization)
        User currentUser = (User) session.getAttribute("user");

        // Fetch the petition by ID
        Petition petition = petitionService.getPetitionById(id);

        if (petition == null) {
            // Petition not found, redirect to an error page or display a message
            return "redirect:/error";
        }

        // Optionally, check if the user is authorized to view the petition
        // For example, only allow the creator or admins to view
        // This logic can be adjusted based on requirements

        model.addAttribute("petition", petition);
        model.addAttribute("user", currentUser); // Pass the user if needed in the view
        return "petitionDetails"; // JSP view to display petition details
    }

    @PostMapping("/{id}/sign")
    public String signPetition(@PathVariable("id") Long id, HttpSession session,
            RedirectAttributes redirectAttributes) {
        // Retrieve the logged-in user from the session
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            // Redirect to login if no user is found in the session
            return "redirect:/auth/login";
        }

        // Fetch the petition by ID
        Petition petition = petitionService.getPetitionById(id);

        if (petition == null || !petition.getStatus().equals("OPEN")) {
            // Petition not found or not open for signing
            redirectAttributes.addFlashAttribute("error", "Cannot sign this petition.");
            return "redirect:/petition/" + id;
        }

        // Check if the user has already signed the petition
        boolean hasSigned = signatureService.hasUserSignedPetition(currentUser.getUserId(), id);
        if (hasSigned) {
            redirectAttributes.addFlashAttribute("error", "You have already signed this petition.");
            return "redirect:/petition/" + id;
        }

        // Sign the petition
        signatureService.signPetition(currentUser, petition);
        redirectAttributes.addFlashAttribute("success", "You have successfully signed the petition.");
        return "redirect:/petition/" + id;
    }

}
