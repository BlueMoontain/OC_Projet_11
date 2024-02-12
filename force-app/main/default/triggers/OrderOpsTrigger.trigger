// Trigger that runs before updating an Order or after deleting an Order
trigger OrderOpsTrigger on Order (before update, after delete) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        // List to store Orders that need to be updated
        List<Order> ordersToUpdate = new List<Order>();
        for (Order ord : Trigger.new) {
            Order oldOrder = Trigger.oldMap.get(ord.Id);
            // Check if the old Order status was 'Draft' and the new Order status is 'Active'
            if (oldOrder.Status == 'Draft' && ord.Status == 'Active') {
                ordersToUpdate.add(ord);
            }
        }
        if (!ordersToUpdate.isEmpty()) {
            // Call the checkProducts method in OrderHandler class
            OrderHandler.checkProducts(ordersToUpdate);
        }
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