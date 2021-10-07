# PWEngagement Changelog
## 3.9.1 (Thursday, October 7, 2021)
#### Bug fixes
* Fixed beacon campaign detection crash
* Added missing metaData for local campaign notification

## 3.9.0 (Monday, March 15, 2021)
#### Features
* Added Message Center Service

## 3.8.1 (Thursday, November 5, 2020)
#### Bug fixes / performance enhancements
* Migrated Mist beacon provider into its own framework
* Built and archived SDK with Xcode 12.

## 3.8.0 (Thursday, September 3rd, 2020)
#### Features
* Migrated to use XCFrameworks

## 3.7.5 (Thursday, April 2nd, 2020)
#### Bug fixes / performance enhacements
* Update Mist location provider to support iOS 13+
* Fix an issue where a deadlock would occur when tracking analytics for a received push notification

## 3.7.4 (Tuesday, October 1st, 2019)
#### Bug fixes / performance enhancements
* Reformat device token string for iOS 13
* Add CoreNoAds subspec

## 3.7.3 (Wednesday, March 13th, 2019)
#### Bug fixes / performance enhancements
* Improve consistency of beacon notifications received from killed app state

## 3.7.2 (Thursday, January 10th, 2019)
#### Bug fixes / performance enhancements
* Update to MistSDK 1.4.2

## 3.7.1 (Thursday, November 29th, 2018)
#### Bug fixes / performance enhancements
* Update to MistSDK 1.3.0

## 3.7.0 (Wednesday, November 14th, 2018)
#### Features
* Update for PWCore 3.8.x compatibility using new automatic screen view analytic events and simplified custom event creation.

## 3.6.1 (Tuesday, Oct 16th, 2018)
#### Features
* Add metadata parsing for on demand broadcasts

#### Bug fixes / performance enhancements
* Fix incorrect campaign type for different broadcasts
* Improve load time for broadcast with promotion data
* Fix crash when opening broadcast from a inactive state

## 3.6.0 (Thursday, Sep 20th, 2018)
#### Features
* Add When-In-Use location permission support

#### Bug fixes / performance enhancements
* Capability to unset all profile attributes by passing a nil dictionary

## 3.5.1 (Monday, Aug 27th, 2018)
#### Bug fixes / performance enhancements
* Fix crash on iOS 12

## 3.5.0 (Monday, Aug 13th, 2018)
#### Bug fixes / performance enhancements
* iOS deployment target increased from 9.0 to 10.0
* Fix device update token call

## 3.4.3 (Thursday, June 14th, 2018)
#### Bug fixes / performance enhancements
* Fixed crash when opening broadcast from an inactive state

## 3.4.2 (Thursday, May 31st, 2018)
#### Features
* Update to PWCore 3.6.x

#### Bug fixes / performance enhancements
* Fixed OS timing issue on first app launch geofence entry

## 3.4.1 (Monday, May 21st, 2018)
#### Bug fixes / performance enhancements
* Fixed first app launch missed notifications

## 3.4.0 (Monday, May 7th, 2018)
#### Features
* Removed location and push notification permission prompting
* Update to PWCore 3.5.x

## 3.3.2 (Monday, Apr 16th, 2018)
#### Features
* Update to PWCore 3.4.x

#### Bug fixes / performance enhancements
* Fixed crash when background location updates aren't enabled

## 3.3.1 (Wednesday, Mar 28th, 2018)
#### Bug fixes / performance enhancements
* Location is no longer required to download promotion data
* Added notification when a user selects When-In-Use only permission

## 3.3.0 (Thursday, Feb 22nd, 2018)
#### Features
* Update to PWCore 3.3.x

#### Bug fixes / performance enhancements
* Fixed crash when starting vBLE.

## 3.2.0 (Monday, Dec 18th, 2017)
* vBLE Beacon Ranging

## 3.1.3 (Thursday, Oct 19th, 2017)
* Update PWCore to 3.1.3

## 3.1.2 (Monday, Oct 16th, 2017)
* Update the framework to dynamic.
* Use latest logger functionality from PWCore.
* Internal Fixes.

## 3.1.1 (Monday, Aug 14th, 2017)
* Fix issue with title for broadcast campaigns.
* Performance improvements and fixes.

## 3.1.0 (Thursday, May 11th, 2017)
* Messaging SDK is now called PWEngagement.
