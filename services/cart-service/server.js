const express = require("express");
const cors = require("cors");
const app = express();
app.use(cors());
app.use(express.json());

let cart = [];

app.get("/api/cart", (req, res) => {
  res.json(cart);
});

app.post("/api/cart", (req, res) => {
  const item = req.body; // { id, name, price, qty }
  cart.push(item);
  res.status(201).json({ message: "Item added to cart", cart });
});

app.delete("/api/cart", (req, res) => {
  cart = [];
  res.json({ message: "Cart cleared" });
});

const PORT = process.env.PORT || 3002;
app.listen(PORT, () => console.log(`Cart service running on ${PORT}`));
