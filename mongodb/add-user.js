db = db.getSiblingDB("admin");
db.auth("admin", "XXXXXXXXX");

db = db.getSiblingDB("nightscoutdb");
db.createUser({
  user: "nsuser",
  pwd: "MOJE-TAJNE-HESLO-PRO-DB",
  roles: [{ role: "readWrite", db: "nightscoutdb" }]
});

// nahrajte do /opt/docker/add-user.js
// heslo asmin musi byt stejne, jako jste zvolili v predpisu mongodb.yaml