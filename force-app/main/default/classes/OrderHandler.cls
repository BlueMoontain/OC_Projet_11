public class OrderHandler {
    // méthode checkProducts invoquée dans un trigger qui se déclenche lorsque le statut de Order passe de draft à active
    public static void checkProducts(List<Order> orders) {
        // Récupère les IDs de tous les Orders
        Set<Id> orderIds = new Set<Id>();
        for (Order order : orders) {
            orderIds.add(order.Id);
        }

        // Récupère les OrderItems associés à tous les Orders
        Map<Id, Order> ordersWithItems = new Map<Id, Order>([SELECT Id, (SELECT Id FROM OrderItems) FROM Order WHERE Id IN :orderIds]);

        // Vérifie chaque Order
        for (Order order : orders) {
            Order ordWithItems = ordersWithItems.get(order.Id);

            // Si l'Order n'a pas de produits, empeche la modification et affiche un message d'erreur
            if (ordWithItems.OrderItems.isEmpty()) {
                order.addError('Aucun produit associé à cette commande. Veuillez saisir des produits avant d\'activer la commande.');
            }
        }
    }
}