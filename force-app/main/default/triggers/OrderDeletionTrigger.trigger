trigger OrderDeletionTrigger on Order (after delete) {
    for (Order ord : Trigger.old) {
        AccountOrderCheck.checkOrders(ord.AccountId);
    }
}