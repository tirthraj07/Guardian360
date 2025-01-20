const mailer = require("../methods/mailer");
const fs = require('fs');
const path = require('path');
const handlebars = require('handlebars');

// Email Service

// send verification code mail
const send_verification_code_mail = async (recipient, code) => {
    try {
        const templatePath = path.join(__dirname, '../template/verification_code_template.hbs');
        const templateSource = fs.readFileSync(templatePath, 'utf-8');
        const template = handlebars.compile(templateSource);
        const htmlToSend = template({ code });
        await mailer.sendEmail(recipient, "Guardians360 - Verification Code", htmlToSend);
        return { success: true, message: 'Email sent successfully' };
    } catch (error) {
        console.error('Error sending verification code email:', error.message);
        return { success: false, message: 'Failed to send email', error: error.message };
    }
}

module.exports = {
    send_verification_code_mail
};