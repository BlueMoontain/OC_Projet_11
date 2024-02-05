// Triiger appelle la méthode checkProducts
trigger OrderStatusTrigger on Order (before update) {
    for (Order order : Trigger.new) {
        if (order.Status == 'Active' && Trigger.oldMap.get(order.Id).Status == 'Draft') {
            OrderProductCheck.checkProducts(order);
        }
    }
}
