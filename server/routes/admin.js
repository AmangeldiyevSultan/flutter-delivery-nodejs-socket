const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const {Product} = require("../models/product");
const Order = require('../models/order');
 
// Add product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;
    console.log(req.body); 
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price, 
      category,
    }) 
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message});
  }
});

// Get all your product
adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try{
  const product = await Product.find({});
  res.json(product); 
  } catch (e){ 
    res.statusCode(500).json({error: e.message}); 
  }
});

//Delete the product
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
  try{
  const {id} = req.body;
  const product = await Product.findByIdAndDelete(id);
  res.json(product);   
  } catch (e){ 
    res.statusCode(500).json({error: e.message}); 
  } 
});

//get all orders
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });  
  }
});

//change order status
adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }  
});

//admin analytics
adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {

    const orders = await Order.find({});

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity * orders[i].products[j].product.price;
      } 
    } 
    // CATEGORY WISE ORDER FETCHING 
    let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
    let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings, 
      booksEarnings,
      fashionEarnings,
    };

    res.json(earnings);  
  } catch (e) {
    res.status(500).json({ error: e.message });
  }  
});

async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
  let categoryOrders = await Order.find({
    "products.product.category": category,
  });

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings +=
        categoryOrders[i].products[j].quantity *
        categoryOrders[i].products[j].product.price;
    }
  }
  return earnings;
}

module.exports = adminRouter;