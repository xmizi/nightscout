db = db.getSiblingDB("admin");
db.auth("admin", "XXXXXXXXX");

db = db.getSiblingDB("nightscoutdb1");
db.createUser({
  user: "nsuser",
  pwd: "MOJE-TAJNE-HESLO-PRO-DB",
  roles: [{ role: "readWrite", db: "nightscoutdb" }]
});