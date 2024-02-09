global class AccountBatch implements Database.Batchable<sObject>, Schedulable {
    
    global void execute(SchedulableContext schedulableContext) {
        // Exécute le batch
        Database.executeBatch(new AccountBatch());
    }

    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        // Récupère les ID de compte qui ont des Orders
        List<Id> accountIdsWithOrders = new List<Id>();
        for (Order order : [SELECT AccountId FROM Order]) {
            accountIdsWithOrders.add(order.AccountId);
        }

        // Récupère les ID de compte qui ont des tâches de rappel
        List<Id> accountIdsWithTasks = new List<Id>();
        for (Task task : [SELECT WhatId FROM Task WHERE Subject = 'Call']) {
            accountIdsWithTasks.add(task.WhatId);
        }

        // Renvoie QueryLocator pour tous les comptes qui n’ont pas d’Order associés ni tâches de rappel
        String query = 'SELECT Id FROM Account WHERE Id NOT IN :accountIdsWithOrders AND Id NOT IN :accountIdsWithTasks';
        return Database.getQueryLocator(query);
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