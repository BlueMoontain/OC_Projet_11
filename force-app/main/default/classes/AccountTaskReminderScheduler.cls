public class AccountTaskReminderScheduler {
    public static void scheduleJob() {
        String cronExp = '0 0 8 ? 1/1 MON#1 *'; // Premier lundi de chaque mois à 8h00
        String jobName = 'AccountTaskReminderJob';
        System.schedule(jobName, cronExp, new AccountTaskReminderBatch());
    }

    // je l appelle dans quelle classe ?
}
