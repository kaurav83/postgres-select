const axios = require('axios');

const http = axios.create({
    baseURL: 'https://randomuser.me/api/'
});

module.exports.loadUsers = async () => {
    const response = await http.get('?results=1000');
    console.log(response);
}