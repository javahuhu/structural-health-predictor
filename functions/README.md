# Firebase Cloud Functions Setup

This directory contains the Firebase Cloud Functions for the Structural Health Predictor app.

## Functions

### 1. `sendVerificationEmail`
- **Trigger**: HTTPS Callable
- **Purpose**: Sends verification code to user's email
- **Parameters**:
  - `email` (string): User's email address
  - `code` (string): 6-digit verification code
  - `expirationMinutes` (number): Code expiration time in minutes
- **Returns**: `{ success: true, message: "..." }`

### 2. `updateUserPassword`
- **Trigger**: HTTPS Callable
- **Purpose**: Updates user's password after verification
- **Parameters**:
  - `email` (string): User's email address
  - `newPassword` (string): New password (minimum 8 characters)
- **Returns**: `{ success: true, message: "..." }`

## Setup Instructions

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 2. Initialize Firebase Functions (First Time Only)
```bash
firebase init functions
```

### 3. Install Dependencies
```bash
cd functions
npm install
```

### 4. Configure Email Service

#### For Local Development (Emulator Testing)

The `.env.local` file is already set up with your Gmail credentials:

```
NODEMAILER_EMAIL=kistmetforyou@gmail.com
NODEMAILER_PASSWORD=qowx mhmk onyp hcoi
```

**Note:** The `.env.local` file is in `.gitignore` and won't be committed to GitHub.

#### For Production Deployment (Firebase Cloud)

Set environment variables using `gcloud`:

```bash
# Set email configuration
gcloud functions deploy sendVerificationEmail \
  --set-env-vars NODEMAILER_EMAIL="kistmetforyou@gmail.com" \
  --set-env-vars NODEMAILER_PASSWORD="qowx mhmk onyp hcoi" \
  --runtime nodejs18

gcloud functions deploy updateUserPassword \
  --set-env-vars NODEMAILER_EMAIL="kistmetforyou@gmail.com" \
  --set-env-vars NODEMAILER_PASSWORD="qowx mhmk onyp hcoi" \
  --runtime nodejs18
```

**OR** set them in Firebase Console:
1. Go to Firebase Console → Functions
2. Click on each function
3. Go to "Runtime settings"
4. Add environment variables under "Runtime environment variables"
5. Add: `NODEMAILER_EMAIL` and `NODEMAILER_PASSWORD`

## Troubleshooting

### Email not sending?
1. Check Firebase Console → Functions → Logs
2. Verify email credentials are correct
3. Ensure "Less secure app access" is enabled (Gmail)
4. Check spam/junk folder

### "sendVerificationEmail is not a function"?
1. Run `firebase deploy --only functions`
2. Wait 30-60 seconds for deployment
3. Restart the app

### Memory/Timeout errors?
Increase function timeout in `firebase.json`:
```json
{
  "functions": {
    "timeoutSeconds": 60
  }
}
```

## How to Get Gmail App Password

1. Go to https://myaccount.google.com/apppasswords
2. You may need to enable 2-Factor Authentication first
3. Select **"Mail"** and **"Windows Computer"** (or your device)
4. Google will generate a **16-character app password**
5. Copy the password and add to `.env.local`:
   ```
   NODEMAILER_PASSWORD=qowx mhmk onyp hcoi
   ```

### 5. Deploy Functions
```bash
firebase deploy --only functions
```

### 6. Test Functions Locally (Optional)
```bash
firebase emulators:start --only functions
```

This will start the emulator and load environment variables from `.env.local`.

## Security Notes

- Never commit real email passwords to git
- Use Firebase environment variables or Secret Manager
- Always validate input parameters
- Add rate limiting for production
- Monitor function logs for suspicious activity

## Next Steps

1. Set up email credentials (see Setup Instructions above)
2. Run `firebase deploy --only functions`
3. Test the forgot password flow in the app
4. Monitor logs for any errors
