const db = require('../db');
const Cryptography = require('../methods/crypto_algo')

// Verification Code Repository -> "verification_codes" table

const get_verification_code_by_email = async (email) => {
    try {

        const verification_code = await db.query('SELECT * FROM verification_codes WHERE email = $1', [email]);
        if (verification_code.rows.length === 0) {
            return null;
        }
        return verification_code.rows[0];
    } catch (error) {
        return error;
    }
}

const generate_verification_code = async (email) => {
    try {
        const crypto = new Cryptography();
        const verification_code = crypto.generateSecureVerificationCode(6);

        const result = await db.query(
            `
            INSERT INTO verification_codes (email, code, expiry) 
            VALUES ($1, $2, NOW() + INTERVAL '5 minutes')
            ON CONFLICT (email) 
            DO UPDATE 
            SET code = $2, expiry = NOW() + INTERVAL '5 minutes'
            RETURNING *
            `,
            [email, verification_code]
        );

        return result.rows[0];
    } catch (error) {
        console.error('Error generating verification code:', error);
        return error;
    }
};


const invalidate_verification_code = async (email) => {
    try {
        const result = await db.query(
            `
            DELETE FROM verification_codes 
            WHERE email = $1
            RETURNING *
            `,
            [email]
        );

        if (result.rowCount === 0) {
            return { valid: false, message: 'No verification code found for this email.' };
        }

        return { valid: true, message: 'Verification code deleted.' };
    } catch (error) {
        console.error('Error deleting verification code:', error);
        return { valid: false, message: 'An error occurred while deleting the code.' };
    }
};

const verify_verification_code = async (email, code) => {
    try {
        const result = await db.query(
            `
            SELECT * FROM verification_codes
            WHERE email = $1 
            AND code = $2 
            AND expiry >= NOW()
            `,
            [email, code]
        );

        if (result.rows.length === 0) {
            invalidate_verification_code(email);
            return { valid: false, message: 'Invalid or expired verification code.' };
        }

        return { valid: true, message: 'Verification code is valid.' };
    } catch (error) {
        console.error('Error verifying verification code:', error);
        return { valid: false, message: 'An error occurred while verifying the code.' };
    }
};

module.exports = {
    get_verification_code_by_email,
    generate_verification_code,
    invalidate_verification_code,
    verify_verification_code
}