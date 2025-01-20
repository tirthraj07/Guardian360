const nodemailer = require('nodemailer');

const EMAIL_USER = process.env.EMAIL_USER;
const EMAIL_PASS = process.env.EMAIL_PASS;

if(!EMAIL_USER || !EMAIL_PASS){
    console.error('FATAL ERROR: EMAIL_USER or EMAIL_PASS is not defined.');
    process.exit(1);
} else {
    console.log('EMAIL_USER and EMAIL_PASS are defined');
}

const transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 587,  // Use 465 for SSL, or 587 for TLS
    auth: {
        user: EMAIL_USER,
        pass: EMAIL_PASS,
    },
});

// Function to send email
const sendEmail = async (to, subject, body) => {
    try{
        // const testResults = await transporter.verify();
        // console.log('Test email results:', testResults);
        await transporter.sendMail({
            from: EMAIL_USER,
            to: to,
            subject: subject,
            html: body,
        });
        console.log(`Email sent to ${to} with subject: ${subject}`);
    } catch(error){
        console.error("Error sending email:", error);
        return error;
    }
}


module.exports = {
    sendEmail
};