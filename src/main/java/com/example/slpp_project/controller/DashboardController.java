package com.example.slpp_project.controller;

import com.example.slpp_project.model.Petition;
import com.example.slpp_project.model.User;
import com.example.slpp_project.service.PetitionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
public class DashboardController {

    @Autowired
    private PetitionService petitionService;

    @GetMapping("/dashboard")
    public String showDashboard(Model model, HttpSession session) {
        // Retrieve the logged-in user from the session
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Redirect to login if no user is found in the session
            return "redirect:/auth/login";
        }

        // Fetch petitions created by the current user
        List<Petition> petitions = petitionService.listPetitionsByUser(user);

        List<Petition> availablePetitions = petitionService.listAvailablePetitions(user);
        model.addAttribute("petitions", petitions);
        model.addAttribute("availablePetitions", availablePetitions); // Other petitions available for signing
        model.addAttribute("user", user); // Ensure 'user' attribute is available in JSP
        return "dashboard"; // Corresponds to dashboard.jsp in /WEB-INF/views/
    }
}