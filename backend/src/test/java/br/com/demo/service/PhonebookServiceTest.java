package br.com.demo.service;

import br.com.demo.exceptions.PhonebookAlreadyExistsException;
import br.com.demo.exceptions.PhonebookNotFoundException;
import br.com.demo.helpers.Mocks;
import br.com.demo.model.Phonebook;
import br.com.demo.persistence.PhonebookPersistence;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

/**
 * Unit test class for the service layer.
 */
class PhonebookServiceTest{
    private PhonebookPersistence persistence = Mocks.getPersistence();
    private List<Phonebook> mockList = Mocks.getList();
    private Phonebook mockItem = Mocks.getItem();
    private Phonebook mockNewItem = Mocks.getNewItem();
    private Phonebook mockExistingItem = Mocks.getExistingItem();
    
    // List all data.
    @Test
    void list(){
        Mockito.when(persistence.findAll()).thenReturn(mockList);
    
        PhonebookService service = new PhonebookService(persistence);
        List<Phonebook> list = service.list();
    
        Assertions.assertEquals(list, mockList);
    }
    
    // Find a phonebook by id.
    @Test
    void findById(){
        Mockito.when(persistence.findById(1)).thenReturn(Optional.of(mockItem));
        Mockito.when(persistence.findById(2)).thenReturn(Optional.empty());
        Mockito.when(persistence.findById(null)).thenThrow(IllegalArgumentException.class);
        
        PhonebookService service = new PhonebookService(persistence);
    
        try{
            Phonebook item = service.findById(1);
            
            Assertions.assertEquals(item, mockItem);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(false);
        }
    
        try{
            service.findById(2);
    
            Assertions.assertTrue(false);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(true);
        }
    
        try{
            service.findById(null);
    
            Assertions.assertTrue(false);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(true);
        }
    }
    
    // Find a phonebook by name.
    @Test
    void findByName(){
        Mockito.when(persistence.findByName("Luke Skywalker")).thenReturn(mockList);
        Mockito.when(persistence.findByName("Han Solo")).thenReturn(null);
        
        PhonebookService service = new PhonebookService(persistence);
        List<Phonebook> list = service.findByName("Luke Skywalker");
    
        Assertions.assertEquals(list, mockList);
    
        list = service.findByName("Han Solo");
    
        Assertions.assertNull(list);
    }

    // Find a phonebook that contains a part of a name.
    @Test
    void findByNameContaining(){
        Mockito.when(persistence.findByNameContaining("Luke")).thenReturn(mockList);
        Mockito.when(persistence.findByNameContaining("Han")).thenReturn(null);
        
        PhonebookService service = new PhonebookService(persistence);
        List<Phonebook> list = service.findByNameContaining("Luke");
        
        Assertions.assertEquals(list, mockList);
        
        list = service.findByNameContaining("Han");
        
        Assertions.assertNull(list);
    }
    
    // Delete a phonebook.
    @Test
    void delete(){
        PhonebookService service = new PhonebookService(persistence);
        
        try{
            service.delete(mockItem);
    
            Assertions.assertTrue(true);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(false);
        }
    
        try{
            service.delete(null);
        
            Assertions.assertTrue(false);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(true);
        }
    }
    
    // Save a phonebook.
    @Test
    void save(){
        Mockito.when(persistence.findByName(mockItem.getName())).thenReturn(null);
        Mockito.when(persistence.save(mockItem)).thenReturn(mockItem);
        
        PhonebookService service = new PhonebookService(persistence);
    
        try{
            Assertions.assertEquals(service.save(mockItem), mockItem);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(false);
        }
        catch(PhonebookAlreadyExistsException e){
            Assertions.assertTrue(false);
        }
    
        Mockito.when(persistence.findByName(mockItem.getName())).thenReturn(Collections.EMPTY_LIST);
        Mockito.when(persistence.save(mockExistingItem)).thenReturn(mockItem);
    
        try{
            Assertions.assertEquals(service.save(mockItem), mockItem);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(false);
        }
        catch(PhonebookAlreadyExistsException e){
            Assertions.assertTrue(false);
        }
    
        try{
            Assertions.assertEquals(service.save(mockExistingItem), mockItem);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(false);
        }
        catch(PhonebookAlreadyExistsException e){
            Assertions.assertTrue(false);
        }

        Mockito.when(persistence.findByName(mockExistingItem.getName())).thenReturn(mockList);
    
        try{
            Assertions.assertEquals(service.save(mockExistingItem), mockItem);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(false);
        }
        catch(PhonebookAlreadyExistsException e){
            Assertions.assertTrue(true);
        }

        try{
            service.save(null);
    
            Assertions.assertTrue(false);
        }
        catch(PhonebookNotFoundException e){
            Assertions.assertTrue(true);
        }
        catch(PhonebookAlreadyExistsException e){
            Assertions.assertTrue(false);
        }
    }
}