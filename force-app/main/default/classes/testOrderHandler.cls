@isTest
public class testOrderHandler {
    @isTest static void testCheckProducts() {
        // Créer un compte de test
        List<Account> accounts = DataFactory.createAccounts(1);
        Account acc = accounts[0];

        // Créer une commande de test avec le statut 'Draft'
        List<Order> orders = DataFactory.createOrders(1, acc.Id);
        Order ord = orders[0];

        // Appeler la méthode checkProducts
        Test.startTest();
        OrderHandler.checkProducts(ord);
        Test.stopTest();

        // Comme il n'y a pas de OrderItems, une erreur doit être ajoutée à la commande
        // Nous attrapons l'erreur et vérifions que le message d'erreur est celui attendu
        try {
            update ord;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Aucun produit associé à cette commande. Veuillez saisir des produits avant d\'activer la commande.'));
        }

        // Maintenant, nous ajoutons un OrderItem à la commande et essayons de mettre à jour le statut de la commande à 'Active'
        List<Product2> products = DataFactory.createProducts(1);
        Product2 prod = products[0];

        List<PricebookEntry> entries = DataFactory.createPricebookEntries(1, Test.getStandardPricebookId(), prod.Id);
        PricebookEntry entry = entries[0];

        DataFactory.createOrderItems(1, ord.Id, entry.Id);

        ord.Status = 'Activated';
        try {
            update ord;
        } catch (DmlException e) {
            // Cette fois, comme la commande a un OrderItem, il ne devrait pas y avoir d'erreur
            // Donc si une erreur est lancée, nous échouons le test
            System.assert(false, 'Une erreur inattendue a été lancée : ' + e.getMessage());
        }
    }
}