public class AccountHandler {
    
    // méthode checkOrders (invoquée dans trigger "OrderOps") qui se déclenche lorsqu'un Order est supprimé
    public static void checkOrders (List<Account> accounts) {
        // Récupére les Order associés au compte
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Orders) FROM Account WHERE Id IN :accounts]);
        
        for (Account acc : accountMap.values()) {
            // Si aucun autre Order n'est associé, décoche la case Active__c
            if (acc.Orders.isEmpty()) {
                acc.Active__c = 'No';
            }
        }
        
        update accountMap.values();
    }
    // méthode createReminder invoquée dans batch programmé via scheduler pour le 1er lundi de chaque mois
    public static task createReminder(Account acc) {
        // Crée une nouvelle tâche de rappel pour le compte
        Task reminder = new Task();
        reminder.WhatId = acc.Id;
        reminder.Subject = 'Call';
        reminder.Status = 'Nouvelle';
        reminder.Priority = 'Normale';
        reminder.ActivityDate = Date.today().addDays(5); // Rappel dans 5 jours
        reminder.ReminderDateTime = DateTime.now().addDays(5); // Rappel automatique dans 5 jours
        return reminder;
    }
    // // méthode pour Scheduler - appel à SchedulerClass.scheduleJob() depuis anonymous method ou test ;
    // public static void scheduleTasksReminder() {
    //     String cronExp = '0 0 5 ? 1/1 MON#1 *'; // Premier lundi de chaque mois à 5h00
    //     String jobName = 'AccountTaskReminderJob';
    //     System.schedule(jobName, cronExp, new AccountTaskReminderBatch());
    // }

    // public static void checkProducts(Order order) {
    //     // Récupère les OrderItems associés à l'Order
    //     Order ord = [SELECT Id, (SELECT Id FROM OrderItems) FROM Order WHERE Id = :order.Id];

    //     // Si l'Order n'a pas de produits, empeche la modification et affiche un message d'erreur
    //     if (ord.OrderItems.isEmpty()) {
    //         order.addError('Aucun produit associé à cette commande. Veuillez saisir des produits avant d\'activer la commande.');
    //     }
    // }
}
  