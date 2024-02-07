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
        Id pricebookId = Test.getStandardPricebookId();
        for(Integer i = 0; i < numOrders; i++) {
            Order ord = new Order(
                Name = 'Test Order ' + i, 
                AccountId = accountId, 
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pricebookId
            );
            orders.add(ord);
        }
        insert orders;
        return orders;
    }

    // Méthode pour créer des produits
    public static List<Product2> createProducts(Integer numProducts) {
        List<Product2> products = new List<Product2>();
        for(Integer i = 0; i < numProducts; i++) {
            Product2 prod = new Product2(
                Name = 'Test Product ' + i,
                IsActive = true
            );
            products.add(prod);
        }
        insert products;
        return products;
    }
    // Méthode pour créer des produits de commande 
    public static List<OrderItem> createOrderItems(Integer numItems, Id orderId, Id pricebookEntryId) {
        List<OrderItem> items = new List<OrderItem>();
        for(Integer i = 0; i < numItems; i++) {
            OrderItem item = new OrderItem(
                OrderId = orderId,
                PricebookEntryId = pricebookEntryId,
                Quantity = 1,
                UnitPrice = 100.0
            );
            items.add(item);
        }
    insert items;
    return items;
}

    // Méthode pour créer des pricebook entries
    public static List<PricebookEntry> createPricebookEntries(Integer numEntries, Id pricebookId, Id productId) {
        List<PricebookEntry> entries = new List<PricebookEntry>();
        for(Integer i = 0; i < numEntries; i++) {
            PricebookEntry entry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = productId,
                UnitPrice = 100.0,
                IsActive = true
            );
        entries.add(entry);
    }
    insert entries;
    return entries;
    }
}