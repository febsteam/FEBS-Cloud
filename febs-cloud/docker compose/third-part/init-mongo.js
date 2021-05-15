db.getSiblingDB('admin')
    .createUser({
        user: 'root',
        pwd: '123456',
        roles: ['readWrite']
    });