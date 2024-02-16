@isTest 
public class testAccountBatch {
    @isTest
    static void testTaskReminderBatch() {
        // set test data using datafactory
        List<Account> accounts = DataFactory.createAccounts(3);
        DataFactory.createOrders(1, accounts[0].Id);
        insert new Task(WhatId = accounts[1].Id, Subject = 'Call');

        // Execute Batch
        Test.startTest();
        AccountBatch batch = new AccountBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that a reminder task has been created for the account without orders and tasks
        Task reminder = [SELECT WhatId FROM Task WHERE WhatId = :accounts[2].Id];
        System.assertNotEquals(null, reminder);

        // Verify that no new task has been created for the accounts with orders or tasks
        List<Task> tasksForAccount0 = [SELECT WhatId FROM Task WHERE WhatId = :accounts[0].Id];
        System.assertEquals(0, tasksForAccount0.size());
        List<Task> tasksForAccount1 = [SELECT WhatId FROM Task WHERE WhatId = :accounts[1].Id AND Subject = 'Call'];
        System.assertEquals(1, tasksForAccount1.size());
    }
    @isTest
    static void testAccountBatchScheduled() {
        // Create test accounts using DataFactory
        List<Account> testAccounts = (List<Account>) DataFactory.createAccounts(3);
    
        // Ensure that there are no orders or tasks associated with the accounts
        for (Account acc : [SELECT Id, (SELECT Id FROM Orders), (SELECT Id FROM Tasks) FROM Account WHERE Id IN :testAccounts]) {
            System.assertEquals(0, acc.Orders.size());
            System.assertEquals(0, acc.Tasks.size());
        }
    
        // Execute the batch
        AccountBatch batch = new AccountBatch();
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();
    
        // verify that a task has been created for each account
        for (Account acc : [SELECT Id, (SELECT Id FROM Tasks) FROM Account WHERE Id IN :testAccounts]) {
            System.assertEquals(1, acc.Tasks.size());
        }
    }
}