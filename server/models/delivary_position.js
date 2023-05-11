const mongoose = require('mongoose');
const ratingSchema = require('./rating');

const delivaryPositionSchema = mongoose.Schema({
    name: {
            type: String,
            require: true,
            trim: true
    },
    latitude: { 
        type: Number,
        require: true,
    },
    longitude: { 
        type: Number,
        require: true,

    },
  
});
 
const DelivaryPosition = mongoose.model('delivaryPosition', delivaryPositionSchema);
module.exports = {DelivaryPosition, delivaryPositionSchema};