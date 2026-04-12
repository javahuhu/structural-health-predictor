const admin = require("firebase-admin");
const functions = require("firebase-functions");
const nodemailer = require("nodemailer");
require("dotenv").config();

admin.initializeApp();

// Get email configuration from environment variables
const EMAIL_USER = process.env.NODEMAILER_EMAIL || process.env.EMAIL_USER;
const EMAIL_PASSWORD = process.env.NODEMAILER_PASSWORD || process.env.EMAIL_PASSWORD;

if (!EMAIL_USER || !EMAIL_PASSWORD) {
  console.warn(
    "⚠️ Email credentials not configured. Set NODEMAILER_EMAIL and NODEMAILER_PASSWORD environment variables."
  );
}

// Configure your email service
// For Gmail: Use App Password (not regular password)
// For other services: Update transporter configuration
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: EMAIL_USER || "your-email@gmail.com",
    pass: EMAIL_PASSWORD || "your-app-password",
  },
});

/**
 * Cloud Function: Send Verification Email
 * Sends a verification code to the user's email address
 */
exports.sendVerificationEmail = functions.https.onCall(async (data, context) => {
  try {
    const { email, code, expirationMinutes } = data;

    if (!email || !code) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Email and code are required"
      );
    }

    const mailOptions = {
      from: process.env.EMAIL_USER || "noreply@structuralhealthpredictor.com",
      to: email,
      subject: "Your Password Reset Verification Code",
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <div style="background: linear-gradient(135deg, #1A1A2E 0%, #0F3460 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
            <h1 style="margin: 0;">Structural Health Predictor</h1>
            <p style="margin: 10px 0 0 0; opacity: 0.9;">Password Reset</p>
          </div>
          
          <div style="padding: 30px; background-color: #f9fafb; border: 1px solid #e5e7eb; border-radius: 0 0 10px 10px;">
            <p style="margin: 0 0 20px 0; color: #374151;">Hello,</p>
            
            <p style="margin: 0 0 20px 0; color: #374151;">
              We received a request to reset your password. Please use the following verification code:
            </p>
            
            <div style="background-color: white; border: 2px dashed #0F3460; padding: 20px; text-align: center; margin: 20px 0; border-radius: 5px;">
              <p style="margin: 0; font-size: 32px; font-weight: bold; color: #0F3460; letter-spacing: 5px;">
                ${code}
              </p>
            </div>
            
            <p style="margin: 0 0 20px 0; color: #6b7280; font-size: 14px;">
              This code will expire in <strong>${expirationMinutes} minutes</strong>.
            </p>
            
            <p style="margin: 0 0 20px 0; color: #374151;">
              If you did not request a password reset, please ignore this email or contact our support team.
            </p>
            
            <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 30px 0;">
            
            <p style="margin: 0; color: #6b7280; font-size: 12px; text-align: center;">
              Do not share this code with anyone. Our team will never ask for it.
            </p>
          </div>
        </div>
      `,
      text: `Your password reset verification code is: ${code}\n\nThis code will expire in ${expirationMinutes} minutes.\n\nIf you did not request this, please ignore this email.`,
    };

    // Send email
    await transporter.sendMail(mailOptions);

    console.log(`✅ Verification email sent successfully to ${email}`);

    return {
      success: true,
      message: "Verification code sent to email",
    };
  } catch (error) {
    console.error("Error sending verification email:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Error sending email: ${error.message}`
    );
  }
});

/**
 * Cloud Function: Update User Password
 * Updates the user's password after successful code verification
 */
exports.updateUserPassword = functions.https.onCall(async (data, context) => {
  try {
    const { email, newPassword } = data;

    if (!email || !newPassword) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Email and new password are required"
      );
    }

    // Validate password strength
    if (newPassword.length < 8) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Password must be at least 8 characters long"
      );
    }

    // Get user by email
    const user = await admin.auth().getUserByEmail(email);

    // Update password
    await admin.auth().updateUser(user.uid, {
      password: newPassword,
    });

    // Optional: Send confirmation email
    const confirmMailOptions = {
      from: process.env.EMAIL_USER || "noreply@structuralhealthpredictor.com",
      to: email,
      subject: "Password Reset Successful",
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <div style="background: linear-gradient(135deg, #1A1A2E 0%, #0F3460 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
            <h1 style="margin: 0;">Structural Health Predictor</h1>
          </div>
          
          <div style="padding: 30px; background-color: #f9fafb; border: 1px solid #e5e7eb; border-radius: 0 0 10px 10px;">
            <p style="margin: 0 0 20px 0; color: #374151;">Hello,</p>
            
            <p style="margin: 0 0 20px 0; color: #374151;">
              ✅ Your password has been successfully reset. You can now log in with your new password.
            </p>
            
            <p style="margin: 0 0 20px 0; color: #374151;">
              If this wasn't you, please contact our support team immediately.
            </p>
            
            <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 30px 0;">
            
            <p style="margin: 0; color: #6b7280; font-size: 12px; text-align: center;">
              Structural Health Predictor Security Team
            </p>
          </div>
        </div>
      `,
    };

    await transporter.sendMail(confirmMailOptions).catch((err) => {
      console.warn("Could not send confirmation email:", err.message);
    });

    console.log(`✅ Password updated successfully for ${email}`);

    return {
      success: true,
      message: "Password updated successfully",
    };
  } catch (error) {
    console.error("Error updating password:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Error updating password: ${error.message}`
    );
  }
});
