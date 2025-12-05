const express = require("express");
const cors = require("cors");
const app = express();
app.use(cors());
app.use(express.json());

app.post("/api/pay", (req, res) => {
  const { amount, method } = req.body;
  res.json({
    status: "SUCCESS",
    amount,
    method,
    transactionId: "TXN-" + Date.now()
  });
});

const PORT = process.env.PORT || 3003;
app.listen(PORT, () => console.log(`Payment service running on ${PORT}`));
