public class OrderHandler {
    // méthode checkProducts invoquée dans un trigger qui se déclenche lorsque le statut de Order passe de draft à active
    public static void checkProducts(Order order) {
        // Récupère les OrderItems associés à l'Order
        Order ord = [SELECT Id, (SELECT Id FROM OrderItems) FROM Order WHERE Id = :order.Id];

        // Si l'Order n'a pas de produits, empeche la modification et affiche un message d'erreur
        if (ord.OrderItems.isEmpty()) {
            order.addError('Aucun produit associé à cette commande. Veuillez saisir des produits avant d\'activer la commande.');
        }
    }
}