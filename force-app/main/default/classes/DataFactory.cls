@isTest
public class DataFactory {
    // Method to create accounts
    public static List<Account> createAccounts(Integer numAccounts) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            accounts.add(acc);
        }
        insert accounts;
        return accounts;
    }

    // Method to create orders
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

    // Method to create products
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
    // Method to create order's items
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

    // Method to create pricebook entries
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