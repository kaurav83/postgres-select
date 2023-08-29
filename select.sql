-- 1. Порахувати кількість товарів, які були продані (sum(quantity) -> orders_to_products)
SELECT sum(quantity) FROM orders_to_products;

-- 2. Кількість товарів, які є на складі (sum(quantity) -> products)
SELECT sum(quantity) FROM products;

-- 3. Середня ціна всіх товарів
SELECT avg(price) FROM products;

-- 4. Середня ціна кожного бренду
SELECT avg(price) FROM products GROUP BY brand;

-- 5. Сума вартості всіх телефонів, які коштують в діапазоні від 1к до 2к
SELECT sum(price) FROM products WHERE price BETWEEN 1000 AND 2000;

-- 6. Кількість моделей кожного бренду
SELECT brand, count(model) AS model_count FROM products GROUP BY brand;

-- 7**. Кількість замовлень кожного користувача, який робив замовлення (групуємо по customer_id в таблиці orders -> count)
SELECT u.id AS user_id, count(o.id) AS order_count FROM users u
LEFT JOIN orders o ON u.id = o.customer_id
GROUP BY u.id ORDER BY u.id;

-- 8. Середня ціна телефону Huawei (якщо немає Huawei - порахуйте середню ціну якогось бренду, який є)
SELECT avg(price) as average_price FROM products WHERE brand = 'Huawei';