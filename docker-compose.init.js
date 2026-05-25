db = db.getSiblingDB('admin');
db.createUser({
  user: '${MONGO_APP_USERNAME}',
  pwd: '${MONGO_APP_PASSWORD}',
  roles: [
    { role: 'readWrite', db: 'myappdb' }
  ]
});
