package com.example.slpp_project.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.slpp_project.model.Signature;

public interface SignatureRepository extends JpaRepository<Signature, Long> {
    /**
     * Checks if a signature exists for a given user and petition.
     *
     * @param userId     The ID of the user.
     * @param petitionId The ID of the petition.
     * @return True if such a signature exists; otherwise, false.
     */
    boolean existsByUser_UserIdAndPetition_PetitionId(Long userId, Long petitionId);
}