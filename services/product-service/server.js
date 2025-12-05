const express = require("express");
const cors = require("cors");
const fs = require("fs");
const { Pool } = require("pg");

const app = express();
app.use(cors());
app.use(express.json());

// ✅ READ AWS SECRET
const secret = JSON.parse(
  fs.readFileSync("/mnt/secrets/shop-db-secret-1", "utf8")
);

// ✅ CONNECT TO POSTGRES
const pool = new Pool({
  host: secret.host,
  user: secret.username,
  password: secret.password,
  database: secret.dbname,
  port: secret.port,
  ssl: { rejectUnauthorized: false }
});

console.log("✅ Connected to DB:", secret.dbname);

//
// ✅ HEALTH CHECK
//
app.get("/health", async (req, res) => {
  const result = await pool.query("SELECT NOW()");
  res.json({ db_time: result.rows[0].now });
});

//
// ✅ GET PRODUCTS
//
app.get("/api/products", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM products ORDER BY id");
    res.json(result.rows);
  } catch (err) {
    console.error("DB error:", err);
    res.status(500).json({ error: "Database error" });
  }
});

//
// ✅ ADD PRODUCT
//
app.post("/api/products", async (req, res) => {
  const { name, price, image } = req.body;

  try {
    await pool.query(
      "INSERT INTO products (name, price, image) VALUES ($1, $2, $3)",
      [name, price, image]
    );
    res.json({ message: "Product added" });
  } catch (err) {
    console.error("Insert error:", err);
    res.status(500).json({ error: "Insert failed" });
  }
});

//
// ✅ START SERVER
//
app.listen(3001, () => {
  console.log("🚀 Product service running on port 3001");
});
