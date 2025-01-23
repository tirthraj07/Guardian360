const db = require('../db');

// User Repository -> "users" table

const get_user_by_email = async (email) => {
    try {
        const user = await db.query('SELECT * FROM users WHERE email = $1', [email]);
        if (user.rows.length === 0) {
            return null;
        }
        return user.rows[0];
    } catch (error) {
        return error;
    }
}

const get_user_by_userid = async (userID) => {
    try {
        const user = await db.query('SELECT * FROM users WHERE userID = $1', [userID]);
        if (user.rows.length === 0) {
            return null;
        }
        return user.rows[0];
    } catch (error) {
        return error;
    }
}

const get_user_by_phone_no = async (phone_no) => {
    try{
        const user = await db.query('SELECT * FROM users WHERE phone_no = $1', [phone_no]);
        if(user.rows.length === 0){
            return null;
        }
        return user.rows[0];
    } catch(error){
        return error;
    }
}

const get_user_by_aadhar_no = async (aadhar_no) => {
    try{
        const user = await db.query('SELECT * FROM users WHERE aadhar_no = $1', [aadhar_no]);
        if(user.rows.length === 0){
            return null;
        }
        return user.rows[0];
    } catch(error){
        return error;
    }
}

const add_user = async (first_name, last_name, email, phone_no, aadhar_hash, public_key, private_key_hash, device_token) => {
    try{
        const user = await db.query('INSERT INTO users (first_name, last_name, email, phone_no, aadhar_no, public_key, private_key, device_token) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *', [first_name, last_name, email, phone_no, aadhar_hash, public_key, private_key_hash, device_token]);
        return user.rows[0];
    } catch(error){
        return error;
    }
}

const add_profile_picture = async (userID, profile_picture_url) => {
    try{
        const user = await db.query('UPDATE users SET profile_pic_location = $1 WHERE userID = $2 RETURNING *', [profile_picture_url, userID]);
        return user.rows[0];
    } catch(error){
        return error;
    }
}

const add_aadhar_location = async (userID, aadhar_location) => {
    try{
        const user = await db.query('UPDATE users SET aadhar_location = $1 WHERE userID = $2 RETURNING *', [aadhar_location, userID]);
        return user.rows[0];
    } catch(error){
        return error;
    }
}

const update_user = async (userID, first_name, last_name, email, phone_no) => {
    try{
        const user = await db.query('UPDATE users SET first_name = $1, last_name = $2, email = $3, phone_no = $4 WHERE userID = $5 RETURNING *', [first_name, last_name, email, phone_no, userID]);
        return user.rows[0];
    } catch(error){
        return error;
    }
}

module.exports = { 
    get_user_by_email,
    get_user_by_userid,
    get_user_by_phone_no,
    get_user_by_aadhar_no,
    add_user,
    add_profile_picture,
    add_aadhar_location,
    update_user
};