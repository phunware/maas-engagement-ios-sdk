Engagement SDK for iOS
==================

Version 3.3.0

Overview
------------
This is Phunware's iOS SDK for Mobile Engagement, a location and notification-based system. Visit https://maas.phunware.com/ for more details and to sign up.

Requirements
------------

- iOS 9.0 or greater
- Xcode 8 or greater

Documentation
------------
Framework documentation is included in the the repository's Documents folder in both HTML and Docset formats.

- [API Reference](http://phunware.github.io/maas-engagement-ios-sdk/)
- Documentation can be found at [developer.phunware.com](https://developer.phunware.com/pages/viewpage.action?pageId=3409591)

Steps to run the sample app
------------
1. Create a new iOS Engagement application in MaaS portal.

2. Go to the directory of sample app and do a `pod install`.

3. Add the following key/value pairs to `Info.plist`:

 * `MaaSAppId`: The application ID from MaaS Portal.
 * `MaaSAccessKey`: The access key from MaaS Portal.
 * `MaaSSignatureKey`: The signature key from MaaS Portal.

4. Configure your app for push notifications.
   * Go to [developer.apple.com](http://developer.apple.com) and create a push notification certificate ([tutorial link](https://www.raywenderlich.com/123862/push-notifications-tutorial)).

   * Once it's created, download the push production certificate and add it to Keychain Access. Then, from Keychain Access, export both the certificate and key. (Right click to view the Export option) as a  .p12 and set a password.

   * Now, log on to the [MaaS Portal](https://maas.phunware.com), navigate to the app created for your application and update the following.
     * Certificate (.p12): Click the grey ellipses button to upload the Production Push Certificate you created on developer.apple.com.
     * Password: The password you setup for the push certificate.
     * Environment: Use Production environment for production apps.  


Attribution
------------

PWEngagement uses the following third-party components.

| Component | Description | License |
|:---------:|:-----------:|:-------:|
|[FMDB](https://github.com/ccgus/fmdb/)|This is an Objective-C wrapper around SQLite: http://sqlite.org/.|[MIT](https://github.com/ccgus/fmdb/blob/master/LICENSE.txt)|

Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

Terms
-----------
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/