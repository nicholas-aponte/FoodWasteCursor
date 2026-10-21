# iOS Beta Testing Guide (TestFlight)

This guide explains how to set up iOS beta testing via TestFlight for the Food Hero app.

## Prerequisites

1. **Apple Developer Account** ($99/year) - [Enroll here](https://developer.apple.com/programs/)
2. **App Store Connect Access** - Automatically included with Developer account
3. **macOS** (for local builds) or use Codemagic/GitHub Actions for cloud builds

## Quick Start (Cloud CI)

### Option A: Codemagic (Recommended)

Codemagic handles code signing automatically through App Store Connect API.

1. Sign up at [codemagic.io](https://codemagic.io) and connect this GitHub repo
2. Go to your app → Settings → Environment variables
3. Create a group called `ios_credentials` with these variables:

| Variable | Description | How to Get |
|----------|-------------|------------|
| `APP_STORE_CONNECT_PRIVATE_KEY` | Contents of the `.p8` API key file | [App Store Connect → Users and Access → Keys](https://appstoreconnect.apple.com/access/api) |
| `APP_STORE_CONNECT_KEY_IDENTIFIER` | Key ID (shown in the Keys table) | Same page as above |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID (shown at top of page) | Same page as above |
| `CM_NOTIFICATION_EMAIL` | Your email for build notifications | Your email |

4. Push to `main` or `release/*` to trigger a build

### Option B: GitHub Actions

1. Go to repo Settings → Secrets and variables → Actions
2. Add these repository secrets:

| Secret | Description |
|--------|-------------|
| `APP_STORE_CONNECT_KEY_ID` | Your Key ID |
| `APP_STORE_CONNECT_ISSUER_ID` | Your Issuer ID |
| `APP_STORE_CONNECT_PRIVATE_KEY_BASE64` | Base64-encoded `.p8` file |
| `APPLE_TEAM_ID` | Your Apple Team ID |
| `IOS_P12_CERTIFICATE_BASE64` | Base64-encoded distribution certificate |
| `IOS_P12_PASSWORD` | Certificate password |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64-encoded provisioning profile |
| `KEYCHAIN_PASSWORD` | Any secure password for temp keychain |

3. Push to `main` or `release/*` to trigger a build

## Creating the App in App Store Connect

Before your first build can upload:

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click "My Apps" → "+" → "New App"
3. Fill in:
   - **Platform:** iOS
   - **Name:** Food Hero
   - **Primary Language:** English
   - **Bundle ID:** `com.foodhero.app` (register if needed)
   - **SKU:** `foodhero-ios`
4. Click "Create"

## Creating an App Store Connect API Key

1. Go to [Users and Access → Keys](https://appstoreconnect.apple.com/access/api)
2. Click "+" to generate a new key
3. Name: `CI Build Key`
4. Access: `App Manager`
5. Click "Generate"
6. **Download the `.p8` key file immediately** (only available once!)
7. Note the Key ID and Issuer ID

## TestFlight Distribution

### Internal Testing (Up to 100 testers)

No review required. Team members only.

1. Go to App Store Connect → Your App → TestFlight
2. Under "Internal Testing", create a group
3. Add team members by email
4. Select the build to test

### External Testing (Up to 10,000 testers)

Requires Beta App Review (24-48 hours).

1. Create an External Testing group
2. Add your build
3. Fill in "What to Test" description
4. Submit for Beta App Review
5. Once approved, add testers by email or enable Public Link

### Public Link

Share a URL that anyone can use to join:

1. In your External Testing group, enable "Public Link"
2. Share the `https://testflight.apple.com/join/XXXXXXXX` URL
3. Optional: Set a tester limit

## App Configuration

The iOS app is configured to:

- **Bundle ID:** `com.foodhero.app`
- **Backend API:** `https://foodwaste-production-23e1.up.railway.app` (baked in at build time)
- **Deployment Target:** iOS 15.0+
- **Theme Color:** Orange (#f97316) matching the web app

### How API URL Works

The production backend URL is set via `VITE_API_URL` environment variable at build time:

```bash
# This is what npm run build:ios does
VITE_API_URL=https://foodwaste-production-23e1.up.railway.app vite build
```

The web app code reads this at runtime from `import.meta.env.VITE_API_URL`.

## Authentication in the iOS App

The iOS app uses the same JWT-based authentication as the web app:

1. User logs in through the webview
2. JWT token is stored in localStorage (accessible to the webview)
3. All API requests include the token in the Authorization header
4. Sessions persist across app restarts

**CORS Consideration:** The backend already allows the production frontend origin. Since the iOS app loads bundled assets with the `capacitor://` scheme, CORS headers from the backend apply to API requests. The backend's `NSAppTransportSecurity` is configured to allow all loads.

## Troubleshooting

### Build fails with signing errors

- Ensure your API key has "App Manager" access
- Verify the `.p8` file contents are correct (starts with `-----BEGIN PRIVATE KEY-----`)
- Check that the Bundle ID matches exactly

### TestFlight build stuck in "Processing"

- Wait 15-30 minutes; Apple processing can be slow
- Check for email notifications about issues
- Verify the app doesn't use any private/restricted APIs

### App crashes on launch

- Check the crash logs in App Store Connect → TestFlight → Crashes
- Most common cause: missing `NSAppTransportSecurity` for HTTP requests
- Verify the production API URL is correct

## Local Development (macOS only)

```bash
# Install dependencies
npm ci

# Build web app with production API
npm run build:ios

# Sync to iOS project
npx cap sync ios

# Open in Xcode
npx cap open ios

# Build and run in Xcode simulator or device
```
