import { useEffect, useState } from "react";
import {
  AppBar, Toolbar, Typography, TextField,
  Container, Grid, Card, CardMedia,
  CardContent, Button, Badge, IconButton,
  Drawer, Box, Dialog, DialogContent,
  MenuItem, Select
} from "@mui/material";
import ShoppingCartIcon from "@mui/icons-material/ShoppingCart";

const API = "/api";

export default function App() {

  const [products, setProducts] = useState([]);
  const [query, setQuery] = useState("");
  const [cart, setCart] = useState([]);
  const [open, setOpen] = useState(false);
  const [selected, setSelected] = useState(null);

  // Filters
  const [category, setCategory] = useState("All");
  const [sort, setSort] = useState("");

  // Payment
  const [payOpen, setPayOpen] = useState(false);
  const [paymentSuccess, setPaymentSuccess] = useState(false);

  // ✅ Fetch Products
  useEffect(() => {
  fetch(`${API}/products`)
    .then(res => res.json())
    .then(data => setProducts(data))
    .catch(console.error);
}, []);

  // ✅ Add Cart
  const addToCart = (item) => {
    fetch(`${API}/api/cart`, {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({...item, qty: 1})
    })
    .then(() => {
      const existing = cart.find(i => i.id === item.id);
      if (existing) {
        setCart(cart.map(i =>
          i.id === item.id ? { ...i, qty: i.qty + 1 } : i
        ));
      } else {
        setCart([...cart, { ...item, qty: 1 }]);
      }
    });
  };

  const addQty = (i) => {
    const updated = [...cart];
    updated[i].qty++;
    setCart(updated);
  };

  const removeItem = (i) => {
    const updated = [...cart];
    if (updated[i].qty > 1) updated[i].qty--;
    else updated.splice(i, 1);
    setCart(updated);
  };

  const filtered = products
    .filter(p => p.name.toLowerCase().includes(query.toLowerCase()))
    .filter(p => category === "All" || p.category === category)
    .sort((a, b) => {
      if (sort === "low") return a.price - b.price;
      if (sort === "high") return b.price - a.price;
      return 0;
    });

  const totalQty = cart.reduce((sum, i) => sum + i.qty, 0);
  const totalPrice = cart.reduce((sum, i) => sum + i.price * i.qty, 0);

  return (
    <>
      {/* HEADER */}
      <AppBar position="sticky">
        <Toolbar>
          <Typography variant="h6" sx={{ flexGrow: 1 }}>
            ShopKart
          </Typography>
          <TextField 
            size="small"
            placeholder="Search products"
            onChange={e => setQuery(e.target.value)}
            sx={{ bgcolor: "white", borderRadius: 1, mr: 2 }}
          />
          <IconButton color="inherit" onClick={() => setOpen(true)}>
            <Badge badgeContent={totalQty} color="error">
              <ShoppingCartIcon />
            </Badge>
          </IconButton>
        </Toolbar>
      </AppBar>

      {/* FILTERS */}
      <Box sx={{ display: "flex", gap: 2, p: 2 }}>
        <Select value={category} onChange={e => setCategory(e.target.value)}>
          <MenuItem value="All">All</MenuItem>
          <MenuItem value="Clothing">Clothing</MenuItem>
          <MenuItem value="Footwear">Footwear</MenuItem>
          <MenuItem value="Electronics">Electronics</MenuItem>
          <MenuItem value="Kitchen">Kitchen</MenuItem>
          <MenuItem value="Others">Others</MenuItem>
        </Select>

        <Select value={sort} onChange={e => setSort(e.target.value)}>
          <MenuItem value="">Sort by Price</MenuItem>
          <MenuItem value="low">Low → High</MenuItem>
          <MenuItem value="high">High → Low</MenuItem>
        </Select>
      </Box>

      {/* PRODUCTS */}
      <Container>
        <Grid container spacing={3}>
          {filtered.map(p => (
            <Grid item xs={12} sm={6} md={4} lg={3} key={p.id}>
              <Card onClick={() => setSelected(p)} sx={{ cursor: "pointer" }}>
                <CardMedia component="img" height="180" image={p.image} />
                <CardContent>
                  <Typography>{p.name}</Typography>
                  <Typography color="primary">₹{p.price}</Typography>
                  <Typography variant="caption">{p.category}</Typography>
                </CardContent>
                <Button
                  fullWidth
                  variant="contained"
                  onClick={(e) => {
                    e.stopPropagation();
                    addToCart(p);
                  }}
                >
                  Add to Cart
                </Button>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>

      {/* CART */}
      <Drawer anchor="right" open={open} onClose={() => setOpen(false)}>
        <Box sx={{ width: 320, p: 2 }}>
          <Typography variant="h6">Cart</Typography>

          {cart.map((item, i) => (
            <Box key={i} sx={{ display: "flex", justifyContent: "space-between", mb: 2 }}>
              <div>
                <strong>{item.name}</strong>
                <p>₹{item.price}</p>
              </div>
              <div>
                <Button onClick={() => removeItem(i)}>-</Button>
                {item.qty}
                <Button onClick={() => addQty(i)}>+</Button>
              </div>
            </Box>
          ))}

          <Typography sx={{ mt: 2 }}>Total: ₹{totalPrice}</Typography>

          <Button
            fullWidth
            variant="contained"
            sx={{ mt: 2 }}
            onClick={() => setPayOpen(true)}
            disabled={cart.length === 0}
          >
            Checkout
          </Button>
        </Box>
      </Drawer>

      {/* DETAILS */}
      <Dialog open={Boolean(selected)} onClose={() => setSelected(null)}>
        {selected && (
          <DialogContent>
            <img src={selected.image} alt="" style={{ width: "100%" }} />
            <Typography variant="h5">{selected.name}</Typography>
            <Typography>₹{selected.price}</Typography>
            <Button fullWidth variant="contained" onClick={() => addToCart(selected)}>
              Add to Cart
            </Button>
          </DialogContent>
        )}
      </Dialog>

      {/* PAYMENT */}
      <Dialog open={payOpen} onClose={() => setPayOpen(false)}>
        <DialogContent>
          <Typography variant="h5">Payment</Typography>
          <Typography>Total: ₹{totalPrice}</Typography>

          <TextField fullWidth label="Card Number" sx={{ mt: 2 }} />
          <TextField fullWidth label="Name on Card" sx={{ mt: 2 }} />
          <TextField fullWidth label="Expiry" sx={{ mt: 2 }} />
          <TextField fullWidth label="CVV" type="password" sx={{ mt: 2 }} />

          <Button fullWidth variant="contained" sx={{ mt: 3 }}
            onClick={() => {
              setPaymentSuccess(true);
              setPayOpen(false);
              setCart([]);
            }}
          >
            Pay ₹{totalPrice}
          </Button>
        </DialogContent>
      </Dialog>

      {/* SUCCESS */}
      <Dialog open={paymentSuccess} onClose={() => setPaymentSuccess(false)}>
        <DialogContent>
          <Typography variant="h5">✅ Payment Successful</Typography>
          <Typography>Your order has been placed</Typography>
          <Button fullWidth sx={{ mt: 2 }} onClick={() => setPaymentSuccess(false)}>
            Close
          </Button>
        </DialogContent>
      </Dialog>

    </>
  );
}
