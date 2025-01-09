// src/main/java/com/example/slpp_project/controller/PetitionRestController.java
package com.example.slpp_project.controller;

import com.example.slpp_project.dto.PetitionDTO;
import com.example.slpp_project.model.Petition;
import com.example.slpp_project.service.PetitionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/slpp")
public class PetitionRestController {

    @Autowired
    private PetitionService petitionService;

    /**
     * 2.1 Return the details of all petitions
     * HTTP GET /slpp/petitions
     */
    @GetMapping("/petitions")
    public PetitionsResponse getAllPetitions(@RequestParam(required = false) String status) {
        List<Petition> petitions;

        if (status != null && !status.isEmpty()) {
            petitions = petitionService.findByStatus(status.toUpperCase());
        } else {
            petitions = petitionService.listPetitions();
        }

        List<PetitionDTO> petitionDTOs = petitions.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());

        return new PetitionsResponse(petitionDTOs);
    }

    /**
     * Utility method to convert Petition to PetitionDTO
     */
    private PetitionDTO convertToDTO(Petition petition) {
        String petitionId = String.valueOf(petition.getPetitionId());
        String status = petition.getStatus();
        String petitionTitle = petition.getTitle();
        String petitionText = petition.getContent();
        String petitioner = petition.getCreatedBy().getEmail(); // Assuming User has getEmail()
        String signatures = String.valueOf(petition.getSignatures() != null ? petition.getSignatures().size() : 0);
        String response = petition.getResponseText();

        return new PetitionDTO(petitionId, status, petitionTitle, petitionText, petitioner, signatures, response);
    }

    /**
     * Wrapper class for the petitions list
     */
    public static class PetitionsResponse {
        private List<PetitionDTO> petitions;

        public PetitionsResponse(List<PetitionDTO> petitions) {
            this.petitions = petitions;
        }

        public List<PetitionDTO> getPetitions() {
            return petitions;
        }

        public void setPetitions(List<PetitionDTO> petitions) {
            this.petitions = petitions;
        }
    }
}
