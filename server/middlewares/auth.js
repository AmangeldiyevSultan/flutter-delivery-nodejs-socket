const jwt = require('jsonwebtoken');

const auth = async (req, res, next) =>{
    try{
        const token = req.header('x-auth-token');
        if(!token)
            return res.statusCode(401).json({msg: 'No auth token, access denied!'});
        const verified = jwt.verify(token, 'passwordKey');
        if(!verified) 
            return res.statusCode(401).json({msg: 'Token    verification  failed, authorization denied!'});
        req.user = verified.id;
        req.token = token;
        next();
        } catch(e){ 
        res.statusCode(500).json({error: e.message});
    }
}

module.exports = auth;