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
        AccountHandler.createReminder(accounts[0]);

        // Vérifie qu'une tâche de rappel a été créée
        Task reminder = [SELECT WhatId, Subject, Status, Priority, ActivityDate, ReminderDateTime FROM Task WHERE WhatId = :accounts[0].Id];
        System.assertNotEquals(null, reminder);
        System.assertEquals('Call', reminder.Subject);
        System.assertEquals('Nouvelle', reminder.Status);
        System.assertEquals('Normale', reminder.Priority);
        System.assertEquals(Date.today().addDays(5), reminder.ActivityDate);
        System.assertEquals(DateTime.now().addDays(5), reminder.ReminderDateTime);
    }

    @isTest static void testCheckProducts() {
        // Prépare les données de test
        List<Account> accounts = DataFactory.createAccounts(1);
        List<Order> orders = DataFactory.createOrders(1, accounts[0].Id);

        // Teste le cas où l'Order a des produits
        DataFactory.createOrderItems(1, orders[0].Id);
        Test.startTest();
        AccountHandler.checkProducts(orders[0]);
        Test.stopTest();

        // Teste le cas où l'Order n'a pas de produits
        delete [SELECT Id FROM OrderItem WHERE OrderId = :orders[0].Id];
        Test.startTest();
        try {
            AccountHandler.checkProducts(orders[0]);
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Aucun produit associé à cette commande. Veuillez saisir des produits avant d\'activer la commande.'));
        }
        Test.stopTest();
    }
}