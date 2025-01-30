const express = require('express');
const api_router = express.Router();
const UserService = require("../../service/user_service");

api_router.get('/', (req,res)=>{
    res.send('Auth Service API Endpoint');
})

/*

PUT /api/device_token

BODY 
    {
        "userID": 35,
        "device_token": "xyz"
    }
*/

api_router.put('/device_token', async (req, res)=>{
    try{
        const {userID, device_token} = req.body
        if(!userID || !device_token) {
            return res.status(400).json({status:"error", message:"Missing fields: userID and/or device_token in request body"})
        }

        const response = await UserService.update_user_device_token(userID, device_token) 
        console.log(response)
        return res.status(200).json({status:"success", message: "device token updated successfully"})

    }
    catch(e){
        console.error("There was an error while updating device token")
        console.error(e)
        return res.status(500).json({status:"error", message: "Internal Server Error"})
    }

})


module.exports = api_router;
