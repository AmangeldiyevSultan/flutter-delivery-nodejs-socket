const express = require('express');
const auth = require('../middlewares/auth');
const {Product} = require('../models/product');  
const productRouter = express.Router();

// /api/product?category=Essential
// req.query.category

// /api/product:category=Essential
// req.params.category 
  

productRouter.get("/api/products/", async (req, res) => {
    try{
        const product = await Product.find({category: req.query.category});
        res.json(product);   
    } catch (e) {
        res.status(500).json({error: e.message});  
    }
});

// /api/product/search/i

// /api/product/search/:hello/:greate
//                             req.params.greate

productRouter.get("/api/products/search/:name", async (req, res) => {
    try{ 

        const productSearch = await Product.find({
            name: {$regex: req.params.name, $options: "i"},
        }); 
        // Ex  
        // iphone
        // ip (it also find with a help regex and options)
        res.json(productSearch); 
    } catch (e){
        res.status(500).json({error: e.message});
    }
});

// create post req
productRouter.post('/api/rate-product', auth, async (req, res)=> {
    try{
        const {id, rating} = req.body;
        let product = await Product.findById(id)

        for(let i = 0; i < product.ratings.length; i++){
            if(product.ratings[i].userId == req.user){
                product.ratings.splice(i , 1);
                break;
            }
        }

        const ratingSchema = {
            userId: req.user,
            rating
        };

        product.ratings.push(ratingSchema);
        product = await product.save();
        res.json(product);  

    } catch (e){
        res.status(500).json({error: e.message});
    }
});

//deal of the day
productRouter.get('/api/deal-of-the-day', async(req, res) => {
    try {
        let products = await Product.find({});
        products = products.sort((a, b) => {
            let aSum = 0;
            let bSum = 0;

            
            for(let i = 0; i < a.ratings.length; i++){
                aSum += a.ratings[i].rating;
            }

            for(let i = 0; i < b.ratings.length; i++){

                bSum += b.ratings[i].rating; 
            }

            return aSum < bSum ? 1 : -1; 
        })

        res.json(products[0]); 
    } catch (e){
        res.status(500).json({error: e.message});
    }
});

module.exports = productRouter;