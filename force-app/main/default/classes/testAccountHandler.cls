@isTest
public class testAccountHandler {
    @isTest static void testCheckOrders() {
        // Prépare les données de test
        List<Account> accounts = DataFactory.createAccounts(1);
        List<Order> orders = DataFactory.createOrders(1, accounts[0].Id);
    
        // Supprime l'Order
        delete orders;
    
        // Appelle la méthode à tester
        AccountHandler.checkOrders(accounts);
    
        // Récupère les données mises à jour
        Account acc = [SELECT Active__c FROM Account WHERE Id = :accounts[0].Id];
    
        // Vérifie que la case Active__c a été décochée
        System.assertEquals('No', acc.Active__c);
    }
    @isTest static void testCreateReminder() {
        // Prépare les données de test
        List<Account> accounts = DataFactory.createAccounts(1);
    
        // Appelle la méthode à tester
        Task reminder = AccountHandler.createReminder(accounts[0]);
    
        // Insère la tâche de rappel
        insert reminder;
    
        // Récupère la tâche de rappel de la base de données
        Task retrievedReminder = [SELECT WhatId, Subject, Status, Priority, ActivityDate, ReminderDateTime FROM Task WHERE Id = :reminder.Id];
    
        // Vérifie que la tâche de rappel a été correctement créée
        System.assertNotEquals(null, retrievedReminder);
        System.assertEquals('Call', retrievedReminder.Subject);
        System.assertEquals('Nouvelle', retrievedReminder.Status);
        System.assertEquals('Normale', retrievedReminder.Priority);
        System.assertEquals(Date.today().addDays(5), retrievedReminder.ActivityDate);
        System.assertEquals(DateTime.now().addDays(5), retrievedReminder.ReminderDateTime);
    }
}