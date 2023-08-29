const { getUsers } = require('./api/fetch');
const { client, User, Product } = require('./models');
const { generatePhones } = require('./utils');
const Order = require('./models/Order');

async function start() {
    await client.connect();

    // ОТРИМАННЯ ЮЗЕРІВ І ДОДАВАННЯ ЇХ ДО БД
    // const usersArray = await getUsers();
    // const response = await User.bulkCreate(usersArray);
    // console.log(response);

    // ГЕНЕРАЦІЯ ТЕЛЕФОНІВ І ДОДАВАННЯ ЇХ ДО БД
    //const phones = generatePhones(200);
    //const response = await Product.bulkCreate(phones);
    //console.log(response);

    // ГЕНЕРАЦІЯ ЗАМОВЛЕНЬ
    // 1. Ми витягаємо всіх юзерів User.findAll()
    // 2. Створили для цих юзерів замовлення і наповнили замовлення рандомними позицями Order.bulkCreate(usersArray, productsArray)
    const {rows: usersArray} = await User.findAll();
    const {rows: productsArray}= await Product.findAll();
    await Order.bulkCreate(usersArray, productsArray);
    await client.end();
}

start();