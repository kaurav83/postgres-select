// з індексу моделей ми віддаємо вже налаштовані і готові до роботи моделі

const { Client } = require('pg');
const { configs } = require('../configs');
const User = require('./User');
const Product = require('./Product');
const Order = require('./Order');

const client = new Client(configs);

User._client = client;
User._tableName = 'users';

Product._client = client;
Product._tableName = 'products';

Order._client = client;

module.exports = {
    client,
    User,
    Product,
    Order
}