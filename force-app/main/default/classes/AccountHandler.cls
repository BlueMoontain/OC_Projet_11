public class AccountHandler {
    
    // checkOrders method (used in OrderOps trigger) triggered when an order is delete
    public static void checkOrders (List<Account> accounts) {
        // Map orders with accounts
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Orders) FROM Account WHERE Id IN :accounts]);
        
        for (Account acc : accountMap.values()) {
            // If no other Order is associated, uncheck the Active__c field
            if (acc.Orders.isEmpty()) {
                acc.Active__c = 'No';
            }
        }        
        update accountMap.values();
    }

    // createReminders method (used in AccountBatch) 
    public static List<Task> createReminders(List<Account> accounts) {
        List<Task> reminders = new List<Task>();
        for (Account account : accounts) {
            // create a new task 
            Task reminder = new Task();
            reminder.WhatId = account.Id;
            reminder.Subject = 'Call';
            reminder.Status = 'Nouvelle';
            reminder.Priority = 'Normale';
            reminder.ActivityDate = Date.today().addDays(5); 
            reminder.ReminderDateTime = DateTime.now().addDays(5);
            reminders.add(reminder);
        }
        return reminders;
    }
    // // méthode pour Scheduler - appel à SchedulerClass.scheduleJob() depuis anonymous method ou test ;
    // public static void scheduleTasksReminder() {
    //     String cronExp = '0 0 5 ? 1/1 MON#1 *'; // Premier lundi de chaque mois à 5h00
    //     String jobName = 'AccountTaskReminderJob';
    //     System.schedule(jobName, cronExp, new AccountTaskReminderBatch());
    // }
}
  