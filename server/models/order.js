const mongoose = require('mongoose');
const { productSchema } = require('./product');
const { recieverLocationSchema } = require('./reciever_location');
const { delivaryPositionSchema } = require('./delivary_position');

const orderSchema = mongoose.Schema({
    products: [
        {
            product: productSchema,
            quantity: {
                type: Number,
                required: true,
            }
        }
    ],
    totalPrice: {
        type: Number,
        required: true
    },
    address:recieverLocationSchema,
    delivaryPosition: delivaryPositionSchema, 
    userId: {  
        required: true,
        type: String,
    },
    orderedAt: {
        type: Number,
        required: true, 
    },
    status: {
        type: Number,
        default: 0,
    }, 
});

const Order = mongoose.model('Order', orderSchema);
module.exports = Order;