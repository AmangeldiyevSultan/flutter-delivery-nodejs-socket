const mongoose = require('mongoose');
const ratingSchema = require('./rating');

const recieverLocationSchema = mongoose.Schema({
    placeInfo: {
            type: String,
            require: true,
            trim: true
    },
    langitude: { 
        type: Number,
        require: true,
    },
    longitude: {
        type: Number,
        require: true,

    },
    buidlingInfo:{
        type: String,
        required: true,
    },
    pincode:{
        type: String,
        required: true,
    }, 
    phoneNumber: {
        type: String,
        required: true,
    },
});
 
const RecieverLocation = mongoose.model('RecieverLocation', recieverLocationSchema);
module.exports = {RecieverLocation, recieverLocationSchema};