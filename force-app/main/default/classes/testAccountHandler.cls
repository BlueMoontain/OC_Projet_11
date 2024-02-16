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
        Account acc = [SELECT ActiveCheckbox__c FROM Account WHERE Id = :accounts[0].Id];
    
        // verify that activeCheckbox__c is unchecked
        System.assertEquals(false, acc.ActiveCheckbox__c);
    }
    @isTest static void testCreateReminder() {
        // set test data using datafactory
        List<Account> accounts = DataFactory.createAccounts(2); 

        // call method tested
        Test.startTest();
        AccountHandler.createReminders(accounts); 
        Test.stopTest();

        // Retrieve tasks
        List<Task> retrievedReminders = [SELECT WhatId, Subject, Status, Priority, ActivityDate, ReminderDateTime FROM Task WHERE WhatId IN :accounts];

        // Verify tasks are created as planned - 2 reminders 
        System.assertEquals(2, retrievedReminders.size());
        for (Task reminder : retrievedReminders) {
            System.assertNotEquals(null, reminder);
            System.assertEquals('Call', reminder.Subject);
            System.assertEquals('Nouvelle', reminder.Status);
            System.assertEquals('Normale', reminder.Priority);
            System.assertEquals(Date.today().addDays(5), reminder.ActivityDate);
            // System.assertEquals(DateTime.now().addDays(5), reminder.ReminderDateTime);
        }
    }
    @isTest static void testCheckProducts() {
        // Create data using DataFactory
    List<Account> accounts = DataFactory.createAccounts(1);
    Account acc = accounts[0];

    // Create two orders
    List<Order> orders = DataFactory.createOrders(2, acc.Id);

    // add orderItem and pricebook entry for first order
    List<Product2> products = DataFactory.createProducts(1);
    Product2 prod = products[0];

    List<PricebookEntry> entries = DataFactory.createPricebookEntries(1, Test.getStandardPricebookId(), prod.Id);
    PricebookEntry entry = entries[0];

    DataFactory.createOrderItems(1, orders[0].Id, entry.Id);

        // Set the status of the first order to 'Active'
        orders[0].status = 'Active';

        // Call checkProducts
        AccountHandler.checkProducts(orders);

        // Verify that first order is updated as required
        try {
            update orders[0];
            System.assert(true, 'No error should be thrown');
        } catch (DmlException e) {
            System.assert(false, 'Une erreur inattendue a été lancée : ' + e.getMessage());
        }

        // Set the status of the second order to 'Active'
        orders[1].status = 'Active';


        // Verify that second order results in an error message
        try {
            update orders[1];
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Aucun produit associé à cette commande. Veuillez saisir des produits avant de valider la commande.'));
        }
}
@isTest static void testScheduleTasksReminder() {
    Test.startTest();
    AccountHandler.scheduleTasksReminder();
    Test.stopTest();

    // Verify that the scheduled job has been created
    CronTrigger[] jobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'AccountTaskReminderJob'];
    System.assertEquals(1, jobs.size(), 'Le travail planifié n\'a pas été créé');
}
}

    // // Verify that first order is updated as required
    // try {
    //     update orders[0];
    //     System.assert(true, 'No error should be thrown');
    // } catch (DmlException e) {
    //     System.assert(false, 'Une erreur inattendue a été lancée : ' + e.getMessage());
    // }

    // // Set the status of the second order to 'Activated'
    // orders[1].status = 'Activated';

    // // Verify that second order results in an error message
    // try {
    //     update orders[1];
    // } catch (DmlException e) {
    //     System.assert(e.getMessage().contains('Aucun produit associé à cette commande. Veuillez saisir des produits avant de valider la commande.'));
    // }
    //     // Create data using DataFactory
    //     List<Account> accounts = DataFactory.createAccounts(1);
    //     Account acc = accounts[0];

    //     // Create several orders
    //     List<Order> orders = DataFactory.createOrders(2, acc.Id);

    //     // add orderItem and pricebook entry for first order
    //     List<Product2> products = DataFactory.createProducts(1);
    //     Product2 prod = products[0];

    //     List<PricebookEntry> entries = DataFactory.createPricebookEntries(1, Test.getStandardPricebookId(), prod.Id);
    //     PricebookEntry entry = entries[0];

    //     DataFactory.createOrderItems(1, orders[0].Id, entry.Id);

    //     // Set the status of the first order to 'Activated'
    //     orders[0].status = 'Activated';

    //     // Verify that first order is updated as required
    //     try {
    //         update orders[0];
    //         System.assert(true, 'No error should be thrown');
    //     } catch (DmlException e) {
    //         System.assert(false, 'Une erreur inattendue a été lancée : ' + e.getMessage());
    //     }

    //     // Verify that second order results in an error message
    //     try {
    //         update orders[1];
    //         orders[1].status = 'Activated';
    //     } catch (DmlException e) {
    //         System.assert(e.getMessage().contains('Aucun produit associé à cette commande. Veuillez saisir des produits avant de valider la commande.'));
    //     }
    // }