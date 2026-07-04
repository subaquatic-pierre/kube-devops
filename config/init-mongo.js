db.createUser({
  user: "app-admin",
  pwd: "password",
  roles: [
    {
      role: "readWrite",
      db: "app",
    },
  ],
});
