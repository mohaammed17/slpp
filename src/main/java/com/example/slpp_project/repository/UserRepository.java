package com.example.slpp_project.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.slpp_project.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsernameAndPassword(String username, String password);

    User findByUsername(String username);

    User findByBioId(String bioId);

    User findByEmail(String email);
}
