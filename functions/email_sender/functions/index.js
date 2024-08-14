const functions = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const fs = require('fs');
const path = require('path');

// Initialize Firebase Admin
admin.initializeApp();

// Set up NodeMailer transporter (using Gmail as an example)
const transporter = nodemailer.createTransport({
    service: 'gmail',
    host: "smtp.gmail.com",
    port: 587,
    secure: false,
    auth: {
        user: 'advantage.redhat@gmail.com',
        pass: 'tpvm xuft xnjf tbrl',
    },
});

// Function to read and parse HTML template
function getHtmlTemplate(filePath, replacements) {
    let template = fs.readFileSync(filePath, 'utf8');
    for (const key in replacements) {
        template = template.replace(new RegExp(`{{${key}}}`, 'g'), replacements[key]);
    }
    return template;
}

// Cloud Function to send email on document creation in 'requests' collection
const onSignupRequest = functions.onDocumentCreated('/requests/{docId}', async (event) => {
    const requestData = event.data.data();
    const docId = event.params.docId;

    const email = docId; // Assuming docId is the email
    const { name, id, userRole } = requestData;

    let emailSubject = '';
    let emailTemplatePath = '';

    // Prepare the email body using the template
    let replacements = { name, id };

    // Determine email content based on user role
    if (userRole === 'staff' || userRole === 'admin') {
        emailSubject = 'Staff Signup Request';
        emailTemplatePath = path.join(__dirname, 'emailTemplates', 'staffEmail.html');
        replacements.imagePath = requestData.imagePath;
    } else if (userRole === 'student') {
        emailSubject = 'Student Signup Request';
        emailTemplatePath = path.join(__dirname, 'emailTemplates', 'studentEmail.html');
        const batchId = requestData.batchId; // Assuming batchId is included in requestData
        replacements.batchId = batchId;
    } else {
        console.log('Unknown user role:', userRole);
        return;
    }

    const emailBody = getHtmlTemplate(emailTemplatePath, replacements);

    // Send the email
    try {
        await transporter.sendMail({
            from: 'admin_vectra@gmail.com',
            to: email,
            subject: emailSubject,
            html: emailBody,
        });
        console.log(`Email sent to ${email} for ${userRole} role`);
    } catch (error) {
        console.error('Error sending email:', error);
    }
});

module.exports = {
    onSignupRequest
};
