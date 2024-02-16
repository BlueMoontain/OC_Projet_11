trigger OrderOpsTrigger on Order (before insert, before update, after delete) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        // Call the checkProducts method in AccountHandler class
        AccountHandler.checkProducts(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isDelete) {
        // Get the AccountIds associated with the deleted Orders
        Set<Id> accountIds = new Set<Id>();
        for (Order ord : Trigger.old) {
            accountIds.add(ord.AccountId);
        }

        // Retrieve the related Accounts based on the AccountIds
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds];

        // Call the checkOrders method in AccountHandler class
        AccountHandler.checkOrders(accounts);
    }
}