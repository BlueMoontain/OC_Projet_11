@isTest
public class testOrderHandler {
    @isTest static void testCheckProducts() {
        // Create data using DataFactory
        List<Account> accounts = DataFactory.createAccounts(1);
        Account acc = accounts[0];

        // Create several orders
        List<Order> orders = DataFactory.createOrders(2, acc.Id);

        // add orderItem and pricebook entry for first order
        List<Product2> products = DataFactory.createProducts(1);
        Product2 prod = products[0];

        List<PricebookEntry> entries = DataFactory.createPricebookEntries(1, Test.getStandardPricebookId(), prod.Id);
        PricebookEntry entry = entries[0];

        DataFactory.createOrderItems(1, orders[0].Id, entry.Id);

        // Call method tested
        OrderHandler.checkProducts(orders);

        // Verify that first order is updated as required
        try {
            update orders[0];
        } catch (DmlException e) {
            System.assert(false, 'Une erreur inattendue a été lancée : ' + e.getMessage());
        }

        // Verify that second order results in an error message
        try {
            update orders[1];
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Aucun produit associé à cette commande. Veuillez saisir des produits avant d\'activer la commande.'));
        }
    }
}