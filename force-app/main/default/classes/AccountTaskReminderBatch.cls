// Classe AccountTaskReminderBatch qui implémente les interfaces Database.Batchable<sObject> et Schedulable
global class AccountTaskReminderBatch implements Database.Batchable<sObject>, Schedulable {
    
    // Méthode execute de l'interface Schedulable qui est appelée lorsque la tâche planifiée est exécutée
    global void execute(SchedulableContext schedulableContext) {
        // Exécute la classe batch AccountTaskReminderBatch
        Database.executeBatch(new AccountTaskReminderBatch());
    }

    // Méthode start de l'interface Database.Batchable<sObject> qui est appelée au début de l'exécution du batch
    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        // Renvoie un QueryLocator pour tous les comptes qui n’ont pas d’Order associés ni tâches de rappel
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order) AND Id NOT IN (SELECT WhatId FROM Task WHERE Subject = \'Call\')');

    }

    // Méthode execute de l'interface Database.Batchable<sObject> qui est appelée pour chaque batch de records
    global void execute(Database.BatchableContext bc, List<Account> accountList) {
        // Parcourt chaque compte dans la liste
        for (Account currentAccount : accountList) {
            // Crée une nouvelle tâche
            Task reminderTask = new Task();
            reminderTask.Subject = 'Call';
            reminderTask.Status = 'Nouvelle';
            reminderTask.Priority = 'Normale';
            reminderTask.ActivityDate = Date.today().addDays(5); // Rappel automatique dans 5 jours
            reminderTask.WhatId = currentAccount.Id; // Associe la tâche au compte 

            insert reminderTask;
        }
    }

    // Méthode finish de l'interface Database.Batchable<sObject> qui est appelée à la fin de l'exécution du batch
    global void finish(Database.BatchableContext bc) {
        // Code à exécuter après la fin du batch
    }
}
