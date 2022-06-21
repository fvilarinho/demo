package br.com.demo.persistence;

import br.com.demo.model.Phonebook;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Interface that implements the persistence layer (JPA + Hibernate).
 *
 * @author fvilarinho
 * @version 1.0.0
 */
@Repository
public interface PhonebookPersistence extends JpaRepository<Phonebook, Integer>{
    // Find all items that contains part of the name.
    List<Phonebook> findByNameContaining(String name);
    
    // Find all items that contains the specified name.
    List<Phonebook> findByName(String name);
}