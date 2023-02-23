const mongoose = require('mongoose');
const ratingSchema = require('./rating');

const productSchema = mongoose.Schema({
    name: {
            type: String,
            require: true,
            trim: true
    },
    desciption: {
        type: String,
        require: true,
        trim: true,
    },
    images: {
        type: [
            {
                type: String,
                require: true,

            }
        ],
    },
    quantity: {
        type: Number,
        require: true,

    },
    price:{
        type: Number,
            required: true,
    },
    category:{
        type: String,
        required: true,
    }, 
    ratings: [
        ratingSchema
    ]
});
 
const Product = mongoose.model('Product', productSchema);
module.exports = {Product, productSchema};