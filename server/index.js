//IMPORT FROM PACKAGES
const e = require('express');
const express = require('express');
const mongoose = require('mongoose');
///IMPORT FROM OTHER FILES
const authRouter = require('./routes/auth'); 
const productRouter = require('./routes/product');
const adminRouter = require('./routes/admin');
const userRouter = require('./routes/user');

///INIT
const PORT = process.env.PORT || 3000;  
const app = express();
const DB = 'mongodb+srv://sultan:1qwerty7@cluster0.aulfxyh.mongodb.net/?retryWrites=true&w=majority'
 

///MIDDLEWARE 
app.use(express.json()); 
app.use(authRouter);   
app.use(adminRouter);   
app.use(productRouter);  
app.use(userRouter);  
 
/// CONNECTION  
mongoose.set("strictQuery", false);
mongoose.connect(DB).then(()=>{
    console.log('Connection successful')
}).catch(e => { 
    console.log(e);  
});  
 
app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port: ${PORT}`); 
}); 