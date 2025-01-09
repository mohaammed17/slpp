package com.example.slpp_project.model;

import java.util.Date;

import jakarta.persistence.*;

@Entity
public class Signature {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "petitionId")
    private Petition petition;

    @ManyToOne
    @JoinColumn(name = "signedBy")
    private User signedBy;

    @Temporal(TemporalType.TIMESTAMP)
    private Date signedDate;

    // Constructors
    public Signature() {
    }

    public Signature(User user, Petition petition) {
        this.user = user;
        this.petition = petition;
        this.signedDate = new Date();
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @ManyToOne
    @JoinColumn(name = "user_id") // Maps the foreign key column in the "signatures" table
    private User user;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Petition getPetition() {
        return petition;
    }

    public void setPetition(Petition petition) {
        this.petition = petition;
    }

    public User getSignedBy() {
        return signedBy;
    }

    public void setSignedBy(User signedBy) {
        this.signedBy = signedBy;
    }

    public Date getSignedDate() {
        return signedDate;
    }

    public void setSignedDate(Date signedDate) {
        this.signedDate = signedDate;
    }

    // Getters and Setters
}
