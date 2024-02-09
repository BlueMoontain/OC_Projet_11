trigger OrderOpsTrigger on Order (before update, after delete) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        List<Order> ordersToUpdate = new List<Order>();
        for (Order ord : Trigger.new) {
            Order oldOrder = Trigger.oldMap.get(ord.Id);
            if (oldOrder.Status == 'Draft' && ord.Status == 'Active') {
                ordersToUpdate.add(ord);
            }
        }
        if (!ordersToUpdate.isEmpty()) {
            OrderHandler.checkProducts(ordersToUpdate);
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