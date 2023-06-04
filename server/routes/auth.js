const express = require('express');
const bcryptjs = require('bcryptjs');
const User = require('../models/users'); 
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth');
 
const authRouter = express.Router();

/// SIGN UP
authRouter.post('/api/signup', async (req, res) => {   
   try{
    const {name, email, password, FCMToken, type} =  req.body; 
    const existingUser = await User.findOne({email});
    if(existingUser){ 
        return res.status(400).json({msg: 'User with same email already exist!'});
    } 
  
    const hashedPassword = await bcryptjs.hash(password, 8);
   
    let user = new User({  
        email, password: hashedPassword, name, FCMToken, type
    })
 
    user = await user.save();
    res.json(user); 
} catch(e){  
    res.status(500).json({error: e.message}); 
} 
});

/// GITHUB SIGN UP 
authRouter.post('/api/githubsignup', async (req, res) => {   
    try{  
     const {name, email, FCMToken} =  req.body; 
     const existingUser = await User.findOne({email});
     if(existingUser){
        var payload = {email}; 
        const token = jwt.sign({
            id: existingUser._id   
        }, "passwordKey");
          
        existingUser.FCMToken = FCMToken; 
        await existingUser.save();   
        return res.status(200).json({token, ...existingUser._doc});
     }  else { 
        var payload = {email};

        let user = new User({ 
            email, password: 'github_sign', name, FCMToken, 
        })  
        await user.save();    
         
        const token = jwt.sign({
            id: user._id 
        }, "passwordKey"); 
        await user.save();
        return res.json({token, ...user._doc});
        } 
 } catch(e){  
     res.status(500).json({error: e.message}); 
 } 
 });

/// TWITTER SIGN UP
authRouter.post('/api/twittersignup', async (req, res) => {   
    try{  
     const {name, email, FCMToken} =  req.body; 
     const existingUser = await User.findOne({email});
     if(existingUser){
        var payload = {email}; 
        const token = jwt.sign({
            id: existingUser._id  
        }, "passwordKey");
          
        existingUser.FCMToken = FCMToken; 
        await existingUser.save();   
        return res.status(200).json({token, ...existingUser._doc});
     }  else { 
        var payload = {email};

        let user = new User({ 
            email, password: 'twitter_sign', name, FCMToken, 
        })  
        await user.save();    
         
        const token = jwt.sign({
            id: user._id 
        }, "passwordKey"); 
        await user.save();
        return res.json({token, ...user._doc});
        } 
 } catch(e){  
     res.status(500).json({error: e.message}); 
 } 
 });

/// GOOGLE SIGN UP
authRouter.post('/api/googlesignup', async (req, res) => {   
    try{ 
     const {name, email, password, FCMToken} =  req.body; 
     const existingUser = await User.findOne({email});
     if(existingUser){
        var payload = {name, email};  
        const token = jwt.sign({
            id: existingUser._id  
        }, "passwordKey");
          
        existingUser.FCMToken = FCMToken; 
        await existingUser.save();   
        return res.status(200).json({token, ...existingUser._doc});
     }  else {
        var payload = {name, email};

        let user = new User({
            email, password: 'google_sign', name, FCMToken, 
        })  
        await user.save();   
         
        const token = jwt.sign({
            id: user._id 
        }, "passwordKey"); 
        await user.save();
        return res.json({token, ...user._doc});
        } 
 } catch(e){  
     res.status(500).json({error: e.message}); 
 } 
 });

///SIGN IN 
authRouter.post('/api/signin', async (req, res)=>{
    try{
        const {email, password, fcmToken} = req.body;

        const user = await User.findOne({email});
        if(!user){
            return res.status(400).json({msg: 'User with this email does not exist!'});
        } 

        const isMatch = await bcryptjs.compare(password, user.password);
        if(!isMatch){
            return res.status(400).json({msg: 'Incorrect password!'});
        } 
        const token = jwt.sign({
            id: user._id 
        }, "passwordKey");
        
        user.FCMToken = fcmToken; 
        await user.save();

        res.json({token, ...user._doc});

    } catch (e){
        res.status(500).json({error: e.message});
    }
});

/// TOKEN-IS-VALID 
authRouter.post("/tokenIsValid", async (req, res)=>{
    try{
    const token = req.header('x-auth-token');
    if(!token) return res.json(false); 
    const verified = jwt.verify(token, 'passwordKey');
    if(!verified) return req.json(false);

    const user = User.findById(verified._id); 
    if(!user) return res.json(false);

    res.json(true); 
} catch (e){
    return res.statusCode(500).json({error: e.message});
  }     
});

///GET-USER-DATA
authRouter.get('/', auth, async (req, res)=>{
    const user = await User.findById(req.user);
    res.json({...user._doc, token: req.token});
});

///CHANGE_USER_INFO 
authRouter.post('/api/changeUserData', auth, async (req, res)=>{
    try{ 
        const user = await User.findById(req.user);
        if(req.body['type'] == 'email'){

            user.email = req.body['title'];
        } else if (req.body['type'] == 'name'){

            user.name = req.body['title'];
        } else if (req.body['type'] == 'address'){

            user.address = req.body['title'];
        } 
 
       await user.save(); 

        res.status(200).json(user);  

 
    } catch(e){  
        res.status(500).json({ error: e.message});
    }
}); 
  
module.exports = authRouter;