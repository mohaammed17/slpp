package com.example.slpp_project.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.slpp_project.model.Petition;
import com.example.slpp_project.model.User;

public interface PetitionRepository extends JpaRepository<Petition, Long> {
    List<Petition> findByCreatedBy(User user);

    List<Petition> findByStatus(String status);

    List<Petition> findByCreatedByNotAndStatus(User user, String status);
}