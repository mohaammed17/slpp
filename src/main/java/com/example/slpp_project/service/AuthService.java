package com.example.slpp_project.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.slpp_project.model.User;
import com.example.slpp_project.repository.UserRepository;
import com.example.slpp_project.util.BioIDUtil;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    public static class InvalidCredentialsException extends RuntimeException {
        public InvalidCredentialsException(String message) {
            super(message);
        }
    }

    public User login(User user) {
        // Fetch the user from the database by username
        User foundUser = userRepository.findByUsername(user.getUsername());

        // Validate the user's credentials
        if (foundUser != null && user.getPassword().equals(foundUser.getPassword())) {
            return foundUser;
        }

        // Throw an exception if credentials are invalid
        throw new RuntimeException("Invalid credentials");
    }

    public User register(User user) throws DuplicateBioIdException, DuplicateEmailException {
        // Check if the username already exists
        if (userRepository.findByUsername(user.getUsername()) != null) {
            throw new RuntimeException("Username already exists");
        }

        // Validate BioID
        if (!BioIDUtil.VALID_BIO_IDS.contains(user.getBioId())) {
            throw new RuntimeException("Invalid BioID");
        }

        // Check for duplicate BioID
        if (userRepository.findByBioId(user.getBioId()) != null) {
            throw new DuplicateBioIdException("BioID already used");
        }

        // Check for duplicate email
        if (userRepository.findByEmail(user.getEmail()) != null) {
            throw new DuplicateEmailException("Email already exists");
        }

        // Set default role for new users
        user.setRole("USER");

        // Save the user to the database without encoding the password
        return userRepository.save(user);
    }

    public static class DuplicateBioIdException extends Exception {
        public DuplicateBioIdException(String message) {
            super(message);
        }
    }

    public static class DuplicateEmailException extends Exception {
        public DuplicateEmailException(String message) {
            super(message);
        }
    }
}
