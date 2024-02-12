@isTest
public class testAccountHandler {
    @isTest static void testCheckOrders() {
        // set test data using datafactory
        List<Account> accounts = DataFactory.createAccounts(1);
        List<Order> orders = DataFactory.createOrders(1, accounts[0].Id);
    
        // delete the orders
        delete orders;
    
        // call method tested
        AccountHandler.checkOrders(accounts);
    
        // get updated accounts
        Account acc = [SELECT Active__c FROM Account WHERE Id = :accounts[0].Id];
    
        // verify that active__c is unchecked
        System.assertEquals('No', acc.Active__c);
    }
    @isTest static void testCreateReminder() {
        // set test data using datafactory
        List<Account> accounts = DataFactory.createAccounts(2); // Crée deux comptes pour tester le traitement en bloc
    
        // call method tested
        List<Task> reminders = AccountHandler.createReminders(accounts); // Modifié pour appeler createReminders et passer une liste de comptes
    
        insert reminders;
    
        // Retrieve tasks
        List<Task> retrievedReminders = [SELECT WhatId, Subject, Status, Priority, ActivityDate, ReminderDateTime FROM Task WHERE Id IN :reminders];
    
        // Verify tasks are created as planned 
        System.assertEquals(2, retrievedReminders.size()); // Vérifie que deux rappels ont été créés
        for (Task reminder : retrievedReminders) {
            System.assertNotEquals(null, reminder);
            System.assertEquals('Call', reminder.Subject);
            System.assertEquals('Nouvelle', reminder.Status);
            System.assertEquals('Normale', reminder.Priority);
            System.assertEquals(Date.today().addDays(5), reminder.ActivityDate);
            System.assertEquals(DateTime.now().addDays(5), reminder.ReminderDateTime);
        }
    }
}