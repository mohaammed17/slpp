package com.example.slpp_project.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.slpp_project.model.Petition;
import com.example.slpp_project.model.User;
import com.example.slpp_project.repository.PetitionRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class PetitionService {

    @Autowired
    private PetitionRepository petitionRepository;

    public Petition createPetition(Petition petition) {
        return petitionRepository.save(petition); // Save the petition and return it
    }

    public List<Petition> listPetitions() {
        return petitionRepository.findAll();
    }

    public List<Petition> findByStatus(String status) {
        return petitionRepository.findByStatus(status.toUpperCase());
    }

    public Petition findById(Long petitionId) {
        Optional<Petition> optionalPetition = petitionRepository.findById(petitionId);
        return optionalPetition.orElse(null); // Handle null as needed
    }

    public void savePetition(Petition petition) {
        petitionRepository.save(petition);
    }

    public List<Petition> listPetitionsByUser(User user) {
        return petitionRepository.findByCreatedBy(user);
    }

    public String deletePetition(Long id) {
        petitionRepository.deleteById(id);
        return "Petition deleted successfully";
    }

    public void respondToPetition(Long id, String responseText) {
        Optional<Petition> optionalPetition = petitionRepository.findById(id);
        if (optionalPetition.isPresent()) {
            Petition petition = optionalPetition.get();
            petition.setStatus("RESPONDED");
            petition.setResponseText(responseText);
            petitionRepository.save(petition);
        } else {
            throw new RuntimeException("Petition not found");
        }
    }

    public void updatePetitionStatus(Long id, String status) {
        Optional<Petition> optionalPetition = petitionRepository.findById(id);
        if (optionalPetition.isPresent()) {
            Petition petition = optionalPetition.get();
            petition.setStatus(status);
            petitionRepository.save(petition);
        } else {
            throw new RuntimeException("Petition not found");
        }
    }

    public Petition getPetitionById(Long id) {
        return petitionRepository.findById(id).orElse(null);
    }

    public Petition updatePetition(Long id, Petition petitionDetails) {
        Optional<Petition> optionalPetition = petitionRepository.findById(id);
        if (optionalPetition.isPresent()) {
            Petition petition = optionalPetition.get();
            petition.setTitle(petitionDetails.getTitle());
            petition.setContent(petitionDetails.getContent());
            petition.setTargetSignatures(petitionDetails.getTargetSignatures());
            petition.setCategory(petitionDetails.getCategory());
            petitionRepository.save(petition);
            return petition;
        }
        return null;
    }

    public List<Petition> listAvailablePetitions(User user) {
        return petitionRepository.findByCreatedByNotAndStatus(user, "OPEN");
    }

}
