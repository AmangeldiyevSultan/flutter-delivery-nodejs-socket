//IMPORT FROM PACKAGES
const e = require('express');
const express = require('express');
const mongoose = require('mongoose');
const adminRouter = require('./routes/admin');
///IMPORT FROM OTHER FILES
const authRouter = require('./routes/auth'); 
const productRouter = require('./routes/product');

///INIT
const PORT = 3000;
const app = express();
const DB = 'mongodb+srv://sultan:1qwerty7@cluster0.aulfxyh.mongodb.net/?retryWrites=true&w=majority'


///MIDDLEWARE
app.use(express.json()); 
app.use(authRouter);   
app.use(adminRouter);   
app.use(productRouter);  
 
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