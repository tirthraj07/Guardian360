const express = require('express');
const auth_router = express.Router();
const UserService = require("../../service/user_service");
const JSON_WEB_TOKEN = require("../../methods/jwt");


auth_router.get('/', (req,res)=>{
    res.send('Auth Endpoint');
})


auth_router.post('/send-code', async (req,res)=>{
    const email = req.body.email;
    
    if(!email){
        res.json({status:"error", message:"email is required"});
    }

    const result = await UserService.send_verification_code(email);
    if(result.success){
        res.json({status:"success", message:"Verification code sent to email"});
    }
    else{
        console.error(result.message);
        res.json({status:"error", message:"Failed to send verification code"});
    } 
});

auth_router.post('/signup', async (req,res)=>{
    let {first_name, last_name, phone_no, email, aadhar_no, code, device_token} = req.body;
    
    console.log(req.body);
    
    if(!first_name || !last_name || !phone_no || !email || !aadhar_no || !code){
        res.status(400).json({status:"error", message:"All fields are required: first_name, last_name, phone_no, email, aadhar_no, code. Optional Fields: device_token"});
        return;
    }

    console.log("All fields are present");

    if(!device_token || device_token === "" || device_token.toString().toLowerCase() === "null" || device_token === "undefined"){
        device_token = null;
    }

    try{
        const verifyCode = await UserService.verify_verification_code(email, code);
        if(!verifyCode.valid){
            console.log(verifyCode.message);
            res.status(400).json({status:"error", message:verifyCode.message});
            return;
        }
        console.log("Verification code verified");

        const user = await UserService.add_user(first_name, last_name, email, phone_no, aadhar_no, device_token);
        
        console.log(`User added, ${user}`);

        const jwt = new JSON_WEB_TOKEN();
        const payload = jwt.createPayload(user.userID, user.email);
        const userToken = jwt.createToken(payload);

        console.log(`Payload ${payload}`);
        conosle.log(`User Token ${userToken}`);
        
        if(user){
            res
            .cookie('userToken' , userToken ,{ httpOnly:true })
            .setHeader('Content-Type', 'application/json')
            .status(201)
            .json(
                {
                    status:"success", 
                    message:"User created successfully", 
                    user: user,
                    userToken: userToken
                }
            );
        }
        else{
            res.status(500).json({status:"error", message:"User not created"});
        }

    } catch(error){
        console.error(error.message);
        res.status(500).json({status:"error", message:"Failed to signup"});
    }

});

auth_router.post('/login', async (req,res)=>{
    let {email, code} = req.body;
    if(!email || !code){
        res.status(400).json({status:"error", message:"All fields are required: email, code"});
        return;
    }

    try{
        const verifyCode = await UserService.verify_verification_code(email, code);
        if(!verifyCode.valid){
            console.log(verifyCode.message);
            res.status(400).json({status:"error", message:verifyCode.message});
            return;
        }
        const user = await UserService.get_user_by_email(email);
        const jwt = new JSON_WEB_TOKEN();
        const payload = jwt.createPayload(user.userID, user.email);
        const userToken = jwt.createToken(payload);
        
        if(user){
            res
            .cookie('userToken' , userToken ,{ httpOnly:true })
            .setHeader('Content-Type', 'application/json')
            .status(201)
            .json(
                {
                    status:"success", 
                    message:"User logged in successfully", 
                    user: user,
                    userToken: userToken
                }
            );
        }
        else{
            res.status(404).json({status:"error", message:"User not found"});
        }

    }
    catch(error){
        console.error(error.message);
        res.status(500).json({status:"error", message:"Failed to login"});
    }

});

module.exports = auth_router;