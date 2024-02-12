public class OrderHandler {
    // Method checkProducts invoked in OrderOps.trigger that fires when the status of Order changes from draft to active
    public static void checkProducts(List<Order> orders) {
        // Récupère les IDs de tous les Orders
        Set<Id> orderIds = new Set<Id>();
        for (Order order : orders) {
            orderIds.add(order.Id);
        }

        // Retrieve OrderItems associated with all Orders
        Map<Id, Order> ordersWithItems = new Map<Id, Order>([SELECT Id, (SELECT Id FROM OrderItems) FROM Order WHERE Id IN :orderIds]);
        for (Order order : orders) {
            Order ordWithItems = ordersWithItems.get(order.Id);

            // If order has no product, prevent modification and display an error message
            if (ordWithItems.OrderItems.isEmpty()) {
                order.addError('Aucun produit associé à cette commande. Veuillez saisir des produits avant d\'activer la commande.');
            }
        }
    }
}