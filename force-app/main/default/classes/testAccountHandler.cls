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
        List<Account> accounts = DataFactory.createAccounts(2); // Crée deux comptes pour tester le traitement en bloc
    
        // Appelle la méthode à tester
        List<Task> reminders = AccountHandler.createReminders(accounts); // Modifié pour appeler createReminders et passer une liste de comptes
    
        // Insère les tâches de rappel
        insert reminders;
    
        // Récupère les tâches de rappel de la base de données
        List<Task> retrievedReminders = [SELECT WhatId, Subject, Status, Priority, ActivityDate, ReminderDateTime FROM Task WHERE Id IN :reminders];
    
        // Vérifie que les tâches de rappel ont été correctement créées
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