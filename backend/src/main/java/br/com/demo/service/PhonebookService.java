package br.com.demo.service;

import br.com.demo.controller.PhonebookValidator;
import br.com.demo.exceptions.PhonebookAlreadyExistsException;
import br.com.demo.exceptions.PhonebookNotFoundException;
import br.com.demo.model.Phonebook;
import br.com.demo.persistence.PhonebookPersistence;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Class that defines the services with the business rules.
 *
 * @author fvilarinho
 * @version 1.0.0
 */
@Service
public class PhonebookService{
    @Autowired
    private PhonebookPersistence persistence;
    
    public PhonebookService(){
        super();
    }
    
    public PhonebookService(PhonebookPersistence persistence){
        this();
        
        this.persistence = persistence;
    }

    // List all data.
    public List<Phonebook> list(){
        return persistence.findAll();
    }
    
    // Find a phonebook by id.
    public Phonebook findById(Integer id) throws PhonebookNotFoundException{
        try{
            Optional<Phonebook> result = persistence.findById(id);
    
            if(result.isPresent())
                return result.get();
    
            throw new PhonebookNotFoundException();
        }
        catch(IllegalArgumentException e){
            throw new PhonebookNotFoundException();
        }
    }
    
    // Find a phonebook by name.
    public List<Phonebook> findByName(String name) { return persistence.findByName(name); }
    
    // Find a phonebook that contains a part of the name.
    public List<Phonebook> findByNameContaining(String name){
        return persistence.findByNameContaining(name);
    }
    
    // Save a phonebook.
    public Phonebook save(Phonebook phonebook) throws PhonebookAlreadyExistsException, PhonebookNotFoundException{
        if(phonebook != null){
            Integer id = phonebook.getId();
            String name = phonebook.getName();
            List<Phonebook> list = persistence.findByName(name);
    
            PhonebookValidator.exists(list, id, name);
    
            return persistence.save(phonebook);
        }
    
        throw new PhonebookNotFoundException();
    }
    
    // Delete a phonebook.
    public void delete(Phonebook phonebook) throws PhonebookNotFoundException{
        if(phonebook != null){
            persistence.delete(phonebook);
            
            return;
        }
        
        throw new PhonebookNotFoundException();
    }
}