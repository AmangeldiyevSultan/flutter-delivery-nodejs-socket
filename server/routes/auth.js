const express = require('express');
const bcryptjs = require('bcryptjs');
const User = require('../models/users'); 

const authRouter = express.Router();

/// SIGN UP
authRouter.post('/api/signup', async (req, res) => {   
   try{
    const {name, email, password} =  req.body; 
    const existingUser = await User.findOne({email});
    if(existingUser){
        return res.status(400).json({msg: 'User with same email already exist!'});
    } 

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
        email, password: hashedPassword, name 
    })  
 
    user = await user.save();
    res.json(user); 
} catch(e){  
    res.status(500).json({error: e.message}); 
} 
});

module.exports = authRouter;