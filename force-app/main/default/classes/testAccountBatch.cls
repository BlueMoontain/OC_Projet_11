@isTest 
public class testAccountBatch {
    @isTest
    static void testTaskReminderBatch() {
        // Prépare les données de test
        List<Account> accounts = DataFactory.createAccounts(2);

        // Exécute la classe Batch
        Test.startTest();
        AccountBatch batch = new AccountBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Vérifie que des tâches de rappel ont été créées pour chaque compte
        for (Account acc : accounts) {
            Task reminder = [SELECT WhatId FROM Task WHERE WhatId = :acc.Id];
            System.assertNotEquals(null, reminder);
        }
    }

    @isTest static void testAccountBatchScheduled() {
        // Prépare les données de test
        List<Account> accounts = DataFactory.createAccounts(2);
        DataFactory.createOrders(1, accounts[0].Id);
        insert new Task(WhatId = accounts[1].Id, Subject = 'Call');
    
        // Programme la classe Batch pour exécution
        Datetime dt = Datetime.now().addMinutes(1);
        String cronExpression = dt.format('s m H d M \'?\' yyyy');
        String jobName = 'TestScheduledJob';
        System.schedule(jobName, cronExpression, new AccountBatch());
    
        // Vérifie que le job a été programmé
        CronTrigger scheduledJob = [SELECT Id, CronExpression, State FROM CronTrigger WHERE CronJobDetail.Name = :jobName];
        System.assertNotEquals(null, scheduledJob);
        System.assertEquals(cronExpression, scheduledJob.CronExpression);
        System.assertEquals('WAITING', scheduledJob.State);
    }
}
