// trigger appelle la méthode checkOrders de la classe AccountOrderCheck
trigger OrderDeletionTrigger on Order (after delete) {
    for (Order ord : Trigger.old) {
        AccountOrderCheck.checkOrders(ord.AccountId);
    }
}