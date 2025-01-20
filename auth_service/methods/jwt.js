const jwt = require('jsonwebtoken')

const SECRET_KEY = process.env.JWT_SECRET_KEY;
if (!SECRET_KEY) {
    console.error('FATAL ERROR: JWT_SECRET_KEY is not defined.');
    process.exit(1);
}
else{
    console.log('JWT_SECRET_KEY is defined');
}

class JSON_WEB_TOKEN{

    createPayload(userID,email){
        return {
            uid: userID,
            email: email
        }
    }

    createToken(payload){
        // return the signed jwt token
        return jwt.sign(payload, SECRET_KEY)
    }

    validateUserToken(userToken){
        try {
            const decodedToken = jwt.verify(userToken, SECRET_KEY); 

            // if (decodedToken.exp < Math.floor(Date.now() / 1000)) {     // check if the token has expired
            //     return { valid: false, reason: 'Token has expired' };   
            // }

            return { valid: true, decodedToken: decodedToken };
        } catch (error) {
            return { valid: false, reason: 'Invalid token: ' + error.message };
        }
    }

}

module.exports = JSON_WEB_TOKEN;