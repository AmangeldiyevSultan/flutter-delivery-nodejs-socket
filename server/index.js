//IMPORT FROM PACKAGES
const express = require('express');
const mongoose = require('mongoose');
const cors = require("cors");
const http = require('http');
const { Server } = require("socket.io");
///IMPORT FROM OTHER FILES

//ROUTES
const authRouter = require('./routes/auth'); 
const productRouter = require('./routes/product');
const adminRouter = require('./routes/admin');
const userRouter = require('./routes/user');
const notificationRouter = require('./routes/notification');

//FUNCTIONS
const {delivaryPositionChange} = require('./service/delivery_position_service');

//MODELS
const Order = require('./models/order');
const User = require('./models/users');

//VARIABLES
const app = express();
const server = http.createServer(app);
const io = new Server(server);

///INIT
const PORT = process.env.PORT || 3000;  
const DB = 'mongodb+srv://sultan:1qwerty7@cluster0.aulfxyh.mongodb.net/?retryWrites=true&w=majority'
 

///MIDDLEWARE 
//FOR WEB
app.use(cors());

//CONVERT JSON
app.use(express.json()); 

//ROUTERS
app.use(authRouter);   
app.use(adminRouter);   
app.use(productRouter);  
app.use(userRouter); 
app.use(notificationRouter);

// SOCKET CONNECTION
io.on('connection', socket => {

    socket.on('join', (orderId)=> {
        socket.join(orderId);
    })

    socket.on('saveDelivaryPosition', (data) => {
        delivaryPositionChange(data);
    });   

    socket.on('deliveryPositionOnMap', (data) =>{   
        io.sockets.in(data.room).emit("changePosition", data);
    }); 

    socket.on('disconnecting', (orderId) =>{   
        console.log('Successfully disconnect');
    }); 
})

/// CONNECTION  
mongoose.set("strictQuery", false);
mongoose.connect(DB).then(()=>{
    console.log('Connection successful')
}).catch(e => { 
    console.log(e);  
});  
 
//OPEN SERVER
server.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port: ${PORT}`); 
}); 