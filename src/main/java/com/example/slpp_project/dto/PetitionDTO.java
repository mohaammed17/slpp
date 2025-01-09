package com.example.slpp_project.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class PetitionDTO {

    @JsonProperty("petition_id")
    private String petitionId;

    private String status;

    @JsonProperty("petition_title")
    private String petitionTitle;

    @JsonProperty("petition_text")
    private String petitionText;

    private String petitioner;

    private String signatures;

    private String response;

    // Constructors
    public PetitionDTO() {
    }

    public PetitionDTO(String petitionId, String status, String petitionTitle, String petitionText, String petitioner,
            String signatures, String response) {
        this.petitionId = petitionId;
        this.status = status;
        this.petitionTitle = petitionTitle;
        this.petitionText = petitionText;
        this.petitioner = petitioner;
        this.signatures = signatures;
        this.response = response;
    }

    // Getters and Setters

    public String getPetitionId() {
        return petitionId;
    }

    public void setPetitionId(String petitionId) {
        this.petitionId = petitionId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPetitionTitle() {
        return petitionTitle;
    }

    public void setPetitionTitle(String petitionTitle) {
        this.petitionTitle = petitionTitle;
    }

    public String getPetitionText() {
        return petitionText;
    }

    public void setPetitionText(String petitionText) {
        this.petitionText = petitionText;
    }

    public String getPetitioner() {
        return petitioner;
    }

    public void setPetitioner(String petitioner) {
        this.petitioner = petitioner;
    }

    public String getSignatures() {
        return signatures;
    }

    public void setSignatures(String signatures) {
        this.signatures = signatures;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }
}
