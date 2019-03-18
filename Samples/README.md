PWEngagement Samples for iOS
====================

## EngagementSample

### Overview
- Display beacon and geofence entry and exit events
- Display monitored geofences
- Manage messages in message center

#### Usage:
1. Navigate to `EngagementSample` directory in Terminal, and execute `pod update` (Cocoapods installation required).

2. Fill out `applicationId`, `accessKey`, and `signatureKey` in AppDelegate.swift.

3. Configure your app for push notifications (if you want to test broadcast notifications).
   * Go to [developer.apple.com](http://developer.apple.com) and create a push notification certificate ([tutorial link](https://www.raywenderlich.com/123862/push-notifications-tutorial)).

   * Once it's created, download the push production certificate and add it to Keychain Access. Then, from Keychain Access, export both the certificate and key. (Right click to view the Export option) as a  .p12 and set a password.

   * Now, log on to the [MaaS Portal](https://maas.phunware.com), navigate to the app created for your application and update the following.
     * Certificate (.p12): Click the grey ellipses button to upload the Production Push Certificate you created on developer.apple.com.
     * Password: The password you setup for the push certificate.
     * Environment: Use Production environment for production apps.  

## EngagementScenarios

### Overview
- Each use case requires setup in the AppDelegate but provides specific examples in the individual view controllers

### LocalNotificationHandlerViewController
- Provides a local notification handler allowing app to intercept and choose to display a custom notification

##### Usage:
- Fill out `applicationId`, `accessKey`, and `signatureKey` in AppDelegate.swift

Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.
Terms
-----------
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
