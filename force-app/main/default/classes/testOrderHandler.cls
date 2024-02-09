@isTest
public class testOrderHandler {
    @isTest static void testCheckProducts() {
        // Créer un compte de test
        List<Account> accounts = DataFactory.createAccounts(1);
        Account acc = accounts[0];

        // Créer plusieurs commandes de test avec le statut 'Draft'
        List<Order> orders = DataFactory.createOrders(2, acc.Id);

        // Ajouter un OrderItem à la première commande
        List<Product2> products = DataFactory.createProducts(1);
        Product2 prod = products[0];

        List<PricebookEntry> entries = DataFactory.createPricebookEntries(1, Test.getStandardPricebookId(), prod.Id);
        PricebookEntry entry = entries[0];

        DataFactory.createOrderItems(1, orders[0].Id, entry.Id);

        // Appeler la méthode checkProducts
        OrderHandler.checkProducts(orders);

        // Vérifier que la première commande peut être mise à jour sans erreur
        try {
            update orders[0];
        } catch (DmlException e) {
            System.assert(false, 'Une erreur inattendue a été lancée : ' + e.getMessage());
        }

        // Vérifier que la deuxième commande a une erreur
        try {
            update orders[1];
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Aucun produit associé à cette commande. Veuillez saisir des produits avant d\'activer la commande.'));
        }
    }
}