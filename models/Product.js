class Product {
    static _client;
    static _tableName;

    static async findAll() {
        return await this._client.query(`
        SELECT * FROM ${this._tableName}
        `)
    }

    static async bulkCreate(productsArray) {
        // 1 дія: зробили VALUES для INSERT'a
        const valuesString = productsArray.map(
            ({brand, model, price, quantity = 1}, i) => `('${brand}', '${model}', 'Test${i}', ${price}, ${quantity})`
            
        ).join(',');
        

        // 2 дія: робимо сам запит на INSERT
        const {rows} = await this._client.query(
            `INSERT INTO ${this._tableName}
            (brand, model, category, price, quantity) VALUES
            ${valuesString} RETURNING *;
            `
        )

        // 3 дія: повертаємо відповідь БД
        return rows;
    }
}

module.exports = Product;