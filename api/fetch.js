module.exports.getUsers = async () => {
    const fetchModule = await import('node-fetch');
    const fetch = fetchModule.default;

    const response = await fetch('https://randomuser.me/api/?results=100&seed=ONL-JSFE2023-1&page=34');
    const data = await response.json();
    return data.results;
}