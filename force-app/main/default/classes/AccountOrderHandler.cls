public class AccountOrderHandler {
    // checkOrders method (used in OrderOps trigger) triggered when an order is delete
    public static void checkOrders (List<Account> accounts) {
        // Map orders with accounts
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Orders) FROM Account WHERE Id IN :accounts]);
        
        for (Account acc : accountMap.values()) {
            // If no other Order is associated, uncheck the ActiveChecbox__c field (= false)
            if (acc.Orders.isEmpty()) {
                acc.ActiveCheckbox__c = false;
            }
        }        
        update accountMap.values();
    }
    
    // Method createReminders will create reminders for a list of accounts.
    public static List<Task> createReminders(List<Account> accounts) {
        List<Task> reminders = new List<Task>();
        for (Account account : accounts) {
            Task reminder = new Task();
            reminder.WhatId = account.Id;
            reminder.Subject = 'Call';
            reminder.Status = 'Nouvelle';
            reminder.Priority = 'Normale';
            reminder.ActivityDate = Date.today().addDays(5); 
            reminders.add(reminder);
        }
        insert reminders;
        return reminders;
    }

    // Method checkProducts will check if an order has products associated with it.
    public static void checkProducts(List<Order> orders) {
            // List to store Orders that need to be updated
            List<Order> ordersToUpdate = new List<Order>();
            for (Order order : orders) {
                // Check if the Order status is 'Active'
                if (order.Status == 'Active') {
                    ordersToUpdate.add(order);
                }
            }
            // If there are no orders to update, return
            if (ordersToUpdate.isEmpty()) {
                return;
            }
            // get IDs for all Orders
            Set<Id> orderIds = new Set<Id>();
            for (Order order : ordersToUpdate) {
                orderIds.add(order.Id);
            }
            // Retrieve OrderItems associated with all Orders
            Map<Id, Order> ordersWithItems = new Map<Id, Order>([SELECT Id, (SELECT Id FROM OrderItems) FROM Order WHERE Id IN :orderIds]);
            for (Order order : ordersToUpdate) {
                Order ordWithItems = ordersWithItems.get(order.Id);
    
            // If order has no product, prevent modification and display an error message
            if (ordWithItems.OrderItems.isEmpty()) {
            order.addError('Aucun produit associé à cette commande. Veuillez saisir des produits avant de valider la commande.');
            }
        }
    }
}


  