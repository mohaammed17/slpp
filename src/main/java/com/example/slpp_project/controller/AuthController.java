package com.example.slpp_project.controller;

import org.springframework.web.bind.annotation.*;

import com.example.slpp_project.service.AuthService;
import com.example.slpp_project.util.BioIDUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.example.slpp_project.model.User;

@Controller
@RequestMapping("auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @GetMapping("/")
    public String home() {
        return "redirect:/auth/login";
    }

    @GetMapping("/login")
    public String showLoginPage(Model model, HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("lastUsername".equals(cookie.getName())) {
                    model.addAttribute("lastUsername", cookie.getValue());
                    break;
                }
            }
        }
        return "login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute User user, Model model, HttpSession session, HttpServletResponse response) {
        try {
            User authenticatedUser = authService.login(user);
            session.setAttribute("user", authenticatedUser);

            // Set cookie for last username
            Cookie usernameCookie = new Cookie("lastUsername", authenticatedUser.getUsername());
            usernameCookie.setMaxAge(60 * 60 * 24 * 7); // 1 week
            usernameCookie.setPath("/");
            response.addCookie(usernameCookie);

            // Redirect based on role
            if ("ADMIN".equalsIgnoreCase(authenticatedUser.getRole())) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/dashboard";
            }
        } catch (AuthService.InvalidCredentialsException e) {
            model.addAttribute("error", "Invalid username or password.");
            return "login";
        } catch (Exception e) {
            model.addAttribute("error", "An unexpected error occurred during login.");
            return "login";
        }
    }

    @PostMapping("/register")
    public String register(@ModelAttribute User user, Model model) {
        try {
            // Validate BioID
            if (!BioIDUtil.VALID_BIO_IDS.contains(user.getBioId())) {
                model.addAttribute("error", "Invalid BioID. Please provide a valid BioID.");
                return "login";
            }

            authService.register(user);
            model.addAttribute("success", "Registration successful! Please login.");
            return "login";
        } catch (AuthService.DuplicateBioIdException e) {
            model.addAttribute("error",
                    "The BioID has already been used by another user or the QR code has already been scanned.");
            return "login";
        } catch (AuthService.DuplicateEmailException e) {
            model.addAttribute("error",
                    "The email address is already associated with an existing registered petitioner.");
            return "login";
        } catch (Exception e) {
            model.addAttribute("error", "Registration failed: " + e.getMessage());
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/auth/login";
    }
}
