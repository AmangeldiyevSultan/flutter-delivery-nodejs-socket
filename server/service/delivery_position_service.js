const axios = require('axios');
const Order = require("../models/order");
const User = require("../models/users"); 

const delivaryPositionChange = async (data) => {
    let order = await Order.findOne({status: 1, _id: data['room']});
    if(order.delivaryPosition === undefined){
        order.delivaryPosition = data;
        return await order.save(); 
 
    }
    if(data['distance'] != undefined && data['distance'] != null){
        let user = await User.findOne({_id: data['client_id']});
        console.log(data['distance']); 
        console.log('room'); 
        console.log(data['room']);
        if(!order.delivaryPosition.getClose && data['getClose']){ 
            var title = 'Your order get close!'
            axios.post(`${data['uri']}/api/send-notification?title=${title}&fcmToken=${user.FCMToken}`);
        
        }    
        if(!order.delivaryPosition.finish && data['finish']){  
            var title = 'Your order came!' 
            axios.post(`${data['uri']}/api/send-notification?title=${title}&fcmToken=${user.FCMToken}`);
        }
        if(order.delivaryPosition.getClose){
            data['getClose'] = true;
        }
        if(order.delivaryPosition.finish){
            data['finish'] = true;
        }  
        order.delivaryPosition = data;
        await order.save(); 
    }    
}  

module.exports = {delivaryPositionChange};