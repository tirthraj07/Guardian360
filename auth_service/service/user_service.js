const UserRepository = require('../repository/user_repository');
const VerificationCodeRepository = require('../repository/verification_code_repository');
const Cryptography = require("../methods/crypto_algo");
const EmailService = require('./email_service');

const CIPHER_KEY = process.env.CIPHER_KEY;

if(!CIPHER_KEY){
    console.error('FATAL ERROR: CIPHER_KEY is not defined.');
    process.exit(1);
}
else {
    console.log('CIPHER_KEY is defined');
}

// User Service -> User Repository -> "users" Table
//             |-> Verification Code Repository -> "verification_codes" Table



// get user by email
const get_user_by_email = async (email) => {
    try {
        const user = await UserRepository.get_user_by_email(email);
        return user;
    } catch (error) {
        return error;
    }
}

// get user by user id
const get_user_by_userid = async (userID) => {
    try {
        const user = await UserRepository.get_user_by_userid(userID);
        return user;
    } catch (error) {
        return error;
    }
}

// get user by aadhar number
const get_user_by_aadhar = async (aadhar_hash) => {
    try {
        const user = await UserRepository.get_user_by_aadhar_no(aadhar_hash);
        return user;
    } catch (error) {
        return error;
    }
}

// get user by phone number
const get_user_by_phone = async (phone_no) => {
    try {
        const user = await UserRepository.get_user_by_phone_no(phone_no);
        return user;
    } catch (error) {
        return error;
    }
}

const add_user = async (first_name, last_name, email, phone_no, aadhar_no, device_token) => {
    try {
        console.log('Adding user:', first_name, last_name, email, phone_no, aadhar_no, device_token);
        const cryto = new Cryptography();
        const aadhar_hash = cryto.generateSaltHash(aadhar_no);        
        const {public_key, private_key} = cryto.generateKeyPair();
        console.log(private_key);
        const salt = aadhar_hash.split(':')[0];
        const encryptedPrivateKey = cryto.encipher(private_key, Buffer.from(CIPHER_KEY), salt);
        const user = await UserRepository.add_user(first_name, last_name, email, phone_no, aadhar_hash, public_key, encryptedPrivateKey, device_token);
        return user;
    } catch (error) {
        return error;
    }
}

// get public and private keys of user by email
const get_keypair_by_email = async (email) => {
    try {
        const user = await UserRepository.get_user_by_email(email);
        const encryptedPrivateKey = user.private_key;
        const public_key = user.public_key;
        const salt = user.aadhar_no.split(':')[0];
        const cryto = new Cryptography();
        const private_key = cryto.decipher(encryptedPrivateKey,Buffer.from(CIPHER_KEY),salt);
        return {public_key, private_key};
    } catch (error) {
        return error;
    }
}

// send verification code
const send_verification_code = async (email) => {
    try {
        const {code, expiry} = await VerificationCodeRepository.generate_verification_code(email);

        EmailService.send_verification_code_mail(email, code)
            .then(() => console.log(`Verification email sent to ${email}`))
            .catch((err) => console.error(`Failed to send verification email: ${err.message}`));

        return { success: true, message: 'Verification code generated successfully.' };

    } catch (error) {
        console.error('Error generating verification code:', error.message);
        return { success: false, message: 'Failed to generate verification code.', error: error.message };
    }
}   

// verify verification code
const verify_verification_code = async (email, code) => {
    try {
        const result = await VerificationCodeRepository.verify_verification_code(email, code);
        return result;
    } catch (error) {
        return error;
    }
}

// update device_token
const update_user_device_token = async (userID, device_token) => {
    try {
        const result = await UserRepository.update_user_device_token(userID, device_token);
        return result;
    } catch (error) {
        return error;
    }
}

module.exports = {
    get_user_by_email,
    get_user_by_userid,
    get_user_by_aadhar,
    get_user_by_phone,
    add_user,
    get_keypair_by_email,
    send_verification_code,
    verify_verification_code,
    update_user_device_token
};