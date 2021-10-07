# PWEngagement Migration Guide
## Upgrade from 3.8.x to 3.9.x

#### General

This release adds API for Message Center Service.

#### CHANGE Detail

#### PWEnagement

*ADDED*

*`static func fetchMessages(startDate: Date, endDate: Date, completion: @escaping (_ messages: [Message]?, _ error: Error?) -> Void)`
*`static func markMessageAsRead(messageIdentifier: String, completion: @escaping (_ error: Error?) -> Void)` 
*`static func markMessageAsUnread(messageIdentifier: String, completion: @escaping (_ error: Error?) -> Void)`
*`static func postMessageEvent(messageIdentifier: String, completion: @escaping (_ error: Error?) -> Void)`

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.9.x'`, then run `pod update` in the Terminal to update the framework.

#### Using Subspecs

1. Open the `Podfile` from your project and add a new pod dependency for each supported beacon provider subspec by using the following format:  `pod 'PWEngagement/<provider>', '3.9.x'`. Finally, run `pod install` in the Terminal to install the beacon provider subspec framework(s).

## Upgrade from 3.7.x to 3.8.x

#### General

This release updates the distribution packaging format to use the new XCFramework binary format.

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.8.x'`, then run `pod update` in the Terminal to update the framework.

#### Using Subspecs

1. Open the `Podfile` from your project and add a new pod dependency for each supported beacon provider subspec by using the following format:  `pod 'PWEngagement/<provider>', '3.8.x'`. Finally, run `pod install` in the Terminal to install the beacon provider subspec framework(s).

## Upgrade from 3.6.x to 3.7.x

#### General

This release includes PWCore 3.8.x which contains new automatic screen view analytic events and simplified analytic event creation.

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.7.x'`, then run `pod update` in the Terminal to update the framework.

2. Check out the [migration guide](https://github.com/phunware/maas-core-ios-sdk/blob/master/MIGRATION.md) for PWCore 3.8.x on updating to the new analytics API.

## Upgrade from 3.5.x to 3.6.x

#### General

This release adds support for When-In-Use location permission.

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.6.x'`, then run `pod update` in the Terminal to update the framework.

## Upgrade from 3.4.x to 3.5.x

#### General

The iOS deployment target of PWEngagement is now 10.0 instead of 9.0. To be compatible with PWEngagement, an application must have a minimum iOS deployment target of 10.0 as well.

#### Upgrade Steps

1. Update your applicable Xcode project settings to a minimum iOS deployment target of 10.0 or greater.

2. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.5.x'`, update your iOS platform to 10.0 or greater, then run `pod update` in the Terminal to update the framework.

## Upgrade from 3.3.x to 3.4.x

#### General

This release adds support for new release of Core and removes location and push notification permission prompting

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.4.x'`, then run `pod update` in the Terminal to update the framework. This will include the latest version of PWCore 3.6.x.

2. To grant push notification permission we recommend following [Apple's best practices](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/SupportingNotificationsinYourApp.html). If permission is not granted the app will not receive push notifications.

3. To grant location permission we recommend following [Apple's best practices](https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services/requesting_always_authorization?language=objc) . To function as designed, PWEngagement needs the user to “Always Allow” location in order to properly search for Geofences activity in the background.  If “Only when in use” or “Don’t allow” is chosen, the app will not monitor for regions. Therefore it will not receive geofence notifications or range on beacons.

## Upgrade from 3.2.x to 3.3.x

#### General

This release adds support for new release of Core

#### Upgrade Steps

1. Open the `Podfile` from your project and change PWEngagement to include `pod 'PWEngagement', '3.3.x'`, then run `pod update` in the Terminal to update the framework. This will include the latest version of PWCore 3.3.x.
