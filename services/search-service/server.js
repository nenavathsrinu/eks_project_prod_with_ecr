const express = require("express");
const cors = require("cors");
const app = express();
app.use(cors());
app.use(express.json());

const products = [
  { id: 1, name: "Dress", price: 999 },
  { id: 2, name: "Red Dress", price: 1299 },
  { id: 3, name: "Shirt", price: 799 },
  { id: 4, name: "Shoes", price: 1999 }
];

app.get("/api/search", (req, res) => {
  const q = (req.query.q || "").toLowerCase();
  const results = products.filter(p => p.name.toLowerCase().includes(q));
  res.json(results);
});

const PORT = process.env.PORT || 3004;
app.listen(PORT, () => console.log(`Search service running on ${PORT}`));
