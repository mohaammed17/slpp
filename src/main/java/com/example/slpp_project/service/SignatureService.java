// src/main/java/com/example/slpp_project/service/SignatureService.java
package com.example.slpp_project.service;

import com.example.slpp_project.model.Petition;
import com.example.slpp_project.model.Signature;
import com.example.slpp_project.model.User;
import com.example.slpp_project.repository.SignatureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SignatureService {

    @Autowired
    private SignatureRepository signatureRepository;

    /**
     * Checks if a user has already signed a specific petition.
     *
     * @param userId     The ID of the user.
     * @param petitionId The ID of the petition.
     * @return True if the user has already signed; otherwise, false.
     */
    public boolean hasUserSignedPetition(Long userId, Long petitionId) {
        return signatureRepository.existsByUser_UserIdAndPetition_PetitionId(userId, petitionId);
    }

    /**
     * Signs a petition on behalf of a user.
     *
     * @param user     The user signing the petition.
     * @param petition The petition to be signed.
     */
    @Transactional
    public void signPetition(User user, Petition petition) {
        Signature signature = new Signature();
        signature.setUser(user);
        signature.setPetition(petition);
        // Optionally, set the signed date if there's a field for it
        signatureRepository.save(signature);
    }
}