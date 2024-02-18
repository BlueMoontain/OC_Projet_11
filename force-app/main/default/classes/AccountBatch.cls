// AccountBatch use "createReminder" method from AccountOrderHandler class to create tasks for accounts that do not have orders or call tasks
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
        List<Task> tasks = AccountOrderHandler.createReminders(scope);
    }
    
        // finish method
    global void finish(Database.BatchableContext batchableContext) {
    }

    // method to schedule the batch
    public static void scheduleTasksReminder() {
        String cronExp = '0 0 5 ? 1/1 MON#1 *'; // first monday of the month 5.00 am
        String jobName = 'AccountTaskReminderJob';
        System.schedule(jobName, cronExp, new AccountBatch());
    }
}