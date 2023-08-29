const _ = require('lodash');

class Order {
    static _client;

    static async bulkCreate(usersArray, productsArray) {
        // 1 дія: створюємо нові замовлення
        // для 2 дії, повертаємо з запиту id-шники створених замовлень
        const ordersValuesString = usersArray.map(user => 
                // оцей масив - всі замовлення поточного переглядаємого юзера в масиві
                // фактично, ми робимо рандомну кількість замовлень для кожного користувача
                new Array(_.random(1, 3, false)) 
                .fill(null)
                .map(() => `(${user.id})`)
                .join(',')
            ).join(',');

        const {rows: orders} = await this._client.query(
            `INSERT INTO orders (customer_id) VALUES ${ordersValuesString} RETURNING id`
        );

        // 2 дія: нагенерувати чек для замовлень
        const productsToOrdersValueString = orders.map(order => {
            const positionsArray = new Array(_.random(1, 4, false))
            .fill(null)
            .map(() => productsArray[_.random(0, productsArray.length - 1)]);
            return [...new Set(positionsArray)]
            .map(product => `(${order.id}, ${product.id}, ${_.random(1, 3, false)})`)
            .join(',');
        }).join(',');

        await this._client.query(
            `
            INSERT INTO orders_to_products (order_id, product_id, quantity) 
            VALUES ${productsToOrdersValueString};
            `
        );
    }
}

module.exports = Order;