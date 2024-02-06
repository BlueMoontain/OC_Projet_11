@isTest
public class DataFactory {
    // Méthode pour créer des comptes
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            accounts.add(acc);
        }
        insert accounts;
        return accounts;
    }

    // Méthode pour créer des commandes
    public static List<Order> createOrders(Integer numOrders, Id accountId) {
        List<Order> orders = new List<Order>();
        for(Integer i = 0; i < numOrders; i++) {
            Order ord = new Order(
                Name = 'Test Order ' + i, 
                AccountId = accountId, 
                Status = 'Draft',
                EffectiveDate = Date.today()
            );
            orders.add(ord);
        }
        insert orders;
        return orders;
    }

    // Méthode pour créer des produits de commande 
    public static List<OrderItem> createOrderItems(Integer numItems, Id orderId) {
        List<OrderItem> items = new List<OrderItem>();
        for(Integer i = 0; i < numItems; i++) {
            OrderItem item = new OrderItem();
            item.OrderId = orderId;
            items.add(item);
        }
        insert items;
        return items;
    }
}