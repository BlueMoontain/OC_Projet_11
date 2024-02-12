// AccountBatch use "createReminder" method from AccountHandler class to create tasks for accounts that do not have orders or call tasks
global class AccountBatch implements Database.Batchable<sObject>, Schedulable {
    
    global void execute(SchedulableContext schedulableContext) {
        // batch execution
        Database.executeBatch(new AccountBatch());
    }

    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        // get IDs from accounts with orders
        List<Id> accountIdsWithOrders = new List<Id>();
        for (Order order : [SELECT AccountId FROM Order]) {
            accountIdsWithOrders.add(order.AccountId);
        }

        // get IDs from accounts with tasks
        List<Id> accountIdsWithTasks = new List<Id>();
        for (Task task : [SELECT WhatId FROM Task WHERE Subject = 'Call']) {
            accountIdsWithTasks.add(task.WhatId);
        }

        // QueryLocator for all accounts without order and without task
        String query = 'SELECT Id FROM Account WHERE Id NOT IN :accountIdsWithOrders AND Id NOT IN :accountIdsWithTasks';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        //create tasks for accounts scoped using creteReminders method
        List<Task> tasksToInsert = AccountHandler.createReminders(scope);
        insert tasksToInsert;
    }
    
        // finish method, could be used to send a confirmation email. 
    global void finish(Database.BatchableContext batchableContext) {
    }
}