//IMPORT FROM PACKAGES
const express = require('express');
const mongoose = require('mongoose');
const cors = require("cors");
///IMPORT FROM OTHER FILES
const authRouter = require('./routes/auth'); 
const productRouter = require('./routes/product');
const adminRouter = require('./routes/admin');
const userRouter = require('./routes/user');
const http = require('http');
const app = express();
const server = http.createServer(app);
const { Server } = require("socket.io");
const Order = require('./models/order');
const io = new Server(server);

///INIT
const PORT = process.env.PORT || 3000;  
const DB = 'mongodb+srv://sultan:1qwerty7@cluster0.aulfxyh.mongodb.net/?retryWrites=true&w=majority'
 

///MIDDLEWARE 
app.use(cors());
app.use(express.json()); 
app.use(authRouter);   
app.use(adminRouter);   
app.use(productRouter);  
app.use(userRouter); 
 

io.on('connection', socket => {

    socket.on('join', (orderId)=> {
        socket.join(orderId);
    })

    socket.on('saveDelivaryPosition', (data) => {
        delivaryPositionChange(data);
    });  

    socket.on('deliveryPositionOnMap', (data) =>{   
        console.log('its okay');  
        io.sockets.in(data.room).emit("changePosition", data);
    });  

    socket.on('disconnecting', (orderId) =>{   
         
        console.log(orderId); 
        console.log('Successfully disconnect');
    }); 
})

const delivaryPositionChange = async (data) => {
    let orders = await Order.find({status: 1});
    for(let i = 0; i < orders.length; i++){
        orders[i].delivaryPosition = data;
        await orders[i].save(); 
    } 
    

 
}

/// CONNECTION  
mongoose.set("strictQuery", false);
mongoose.connect(DB).then(()=>{
    console.log('Connection successful')
}).catch(e => { 
    console.log(e);  
});  
 
server.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port: ${PORT}`); 
}); 