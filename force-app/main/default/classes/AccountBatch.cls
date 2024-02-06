global class AccountBatch implements Database.Batchable<sObject>, Schedulable {
    
    global void execute(SchedulableContext schedulableContext) {
        // Exécute le batch
        Database.executeBatch(new AccountBatch());
    }
    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        
        // Renvoie QueryLocator pour tous les comptes qui n’ont pas d’Order associés ni tâches de rappel
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order) AND Id NOT IN (SELECT WhatId FROM Task WHERE Subject = \'Call\')');
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        // Crée des tâches pour ces comptes
        List<Task> tasksToInsert = new List<Task>();
        for (Account acc : scope) {
            tasksToInsert.add(AccountHandler.createReminder(acc));
        }
        insert tasksToInsert;
    }

    global void finish(Database.BatchableContext batchableContext) {
    }
}
