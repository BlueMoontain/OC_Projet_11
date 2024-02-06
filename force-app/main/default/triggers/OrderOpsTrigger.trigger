trigger OrderOpsTrigger on Order (before update, after delete) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Order order : Trigger.new) {
            if (order.Status == 'Active' && Trigger.oldMap.get(order.Id).Status == 'Draft') {
                // Appelle la méthode checkProducts dans AccountHandler
                AccountHandler.checkProducts(order);
            }
        }
    }

    if (Trigger.isAfter && Trigger.isDelete) {
        // Récupère les Ids des comptes associés aux commandes supprimées
        Set<Id> accountIds = new Set<Id>();
        for (Order ord : Trigger.old) {
            accountIds.add(ord.AccountId);
        }

        // Récupère les comptes à partir des Ids
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds];

        // Appelle la méthode checkOrders dans AccountHandler
        AccountHandler.checkOrders(accounts);
    }
}