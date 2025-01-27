const { 
    createHash, scryptSync, randomBytes, timingSafeEqual,
    createCipheriv, createDecipheriv,
    generateKeyPairSync,
    publicEncrypt, privateDecrypt, getRandomValues

} = require('crypto')


class Cryptography{
    generateSalt(){
        return randomBytes(8);
    }

    generateSaltHash(password){
        const salt = this.generateSalt().toString('hex');
        const hashedPassword =  scryptSync(password, salt, 64).toString('hex');
        return `${salt}:${hashedPassword}`;
    }

    verifyPassword(password, hash){
        const [salt, key] = hash.split(':');
        const hashedBuffer = scryptSync(password,salt,64);
        const keyBuffer = Buffer.from(key,'hex');
        return timingSafeEqual(hashedBuffer, keyBuffer)
    }

    encipher(message, key, iv){
        const cipher =  createCipheriv('aes-256-cbc', key, iv);
        const encryptedMessage = cipher.update(message, 'utf-8', 'hex') + cipher.final('hex');
        return encryptedMessage;
    }

    decipher(ciphertext, key, iv){
        const decipher = createDecipheriv('aes-256-cbc', key, iv)
        decipher.setAutoPadding(false)
        const message = decipher.update(ciphertext,'hex','utf-8') + decipher.final('utf-8');
        return message;
    }

    generateKeyPair(){
        let  {privateKey , publicKey } = generateKeyPairSync('rsa', {
            modulusLength: 2048,
            publicKeyEncoding:{
                type: 'spki',
                format: 'pem',
            },
            privateKeyEncoding:{
                type: 'pkcs8',
                format: 'pem',
            }
        })
        return {private_key: privateKey, public_key: publicKey}
    }

    encryptUsingPublicKey(message, publicKey){
        const encryptedMessage = publicEncrypt(
            {
                key: publicKey
            },
            Buffer.from(message),

        ).toString('hex');
        return encryptedMessage;
    }

    decryptUsingPrivateKey(encryptedMessage, privateKey){
        const decryptedMessage = privateDecrypt(
            privateKey,
            Buffer.from(encryptedMessage, 'hex')
        ).toString('utf-8');
        return decryptedMessage;
    }

    generateSecureVerificationCode(length = 6) {
        // const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        const characters = '70'
        let code = '';
        const array = new Uint8Array(length);
    
        getRandomValues(array);
    
        for (let i = 0; i < length; i++) {
            const randomIndex = array[i] % characters.length;
            code += characters[randomIndex];
        }
    
        return code;
    }
}


module.exports = Cryptography;