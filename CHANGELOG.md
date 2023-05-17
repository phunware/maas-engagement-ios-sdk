# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.13.0][] - 2023-05-17

### Features

- Exposed 'promotionExpirationDate' property to messages.

### Changed

- Updated to PWCore 3.12.1

## [3.12.0][] - 2023-03-30

### Removed

-  Removed support for Mist vBLE

## [3.11.1][] - 2022-05-24

### Fixed

- Fixed issues of not sending GEOFENCE_EXIT event when we move outside of a geofence while the app is in the background.

## [3.11.0][] - 2022-03-05

### Features

- Reworked the existing push notifications integration flow, so that it is easy and explicit for SDK adopters to configure within their own apps.  Please see migration guide for details.
- Renamed analytics from `MESSAGE_RECEIVED` to `NOTIFICATION_RECEIVED` and `MESSAGE_VIEWED` to `NOTIFICATION_CLICKED`

### Fixed

- Fixed issues with cancelling last monitored campaigns for a region
- Fixed issues with updating monitored campaigns

## [3.10.2][] - 2021-10-29

### Changed

- Updated to PWCore 3.12.0

## [3.10.1][] - 2021-10-18

### Fixed

- Fixed beacon campaign detection crash
- Added missing metaData for local campaign notification

## [3.10.0][] - 2021-07-28

### Changed

- Updated to PWCore 3.11.0

### Added

- iOS deployment target increased from 10.0 to 13.0

## [3.9.1][] - 2021-10-07

### Fixed

- Fixed beacon campaign detection crash
- Added missing metaData for local campaign notification

## [3.9.0][] - 2021-03-15

### Added

- Added Message Center Service

## [3.8.1][] - 2020-11-05

### Changed

- Migrated Mist beacon provider into its own framework
- Built and archived SDK with Xcode 12.

## [3.8.0][] - 2020-09-03

### Changed

- Migrated to use XCFrameworks

## [3.7.5][] - 2020-04-02

### Changed

- Updated Mist location provider to support iOS 13+

### Fixed

- Fixed deadlock when tracking analytics for a received push notification

## [3.7.4][] - 2019-10-01

### Changed

- Reformatted device token string for iOS 13
- Added CoreNoAds subspec

## [3.7.3][] - 2019-03-13

### Changed

- Improved consistency of beacon notifications received from killed app state

## [3.7.2][] - 2019-01-10

### Changed

- Updated to MistSDK 1.4.2

## [3.7.1][] - 2018-11-29

### Changed

- Updated to MistSDK 1.3.0

## [3.7.0][] - 2018-11-14

### Changed

- Updated for PWCore 3.8.x compatibility using new automatic screen view analytic events and simplified custom event creation.

## [3.6.1][] - 2018-10-16

### Added

- Added metadata parsing for on demand broadcasts

### Fixed

- Fixed incorrect campaign type for different broadcasts
- Fixed crash when opening broadcast from a inactive state

### Changed

- Improved load time for broadcast with promotion data

## [3.6.0][] - 2018-09-20

### Added

- Added When-In-Use location permission support
- Added capability to unset all profile attributes by passing a nil dictionary

## [3.5.1][] - 2018-08-27

### Fixed

- Fixed crash on iOS 12

## [3.5.0][] - 2018-08-13

### Changed

- Increased iOS deployment target from 9.0 to 10.0

### Fixed

- Fixed device update token call

## [3.4.3][] - 2018-06-14

### Fixed

- Fixed crash when opening broadcast from an inactive state

## [3.4.2][] - 2018-05-31

### Changed

- Updated to PWCore 3.6.x

### Fixed

- Fixed OS timing issue on first app launch geofence entry

## [3.4.1][] - 2018-05-21

### Fixed

- Fixed first app launch missed notifications

## [3.4.0][] - 2018-05-07

### Changed

- Removed location and push notification permission prompting
- Updated to PWCore 3.5.x

## [3.3.2][] - 2018-04-16

### Changed

- Updated to PWCore 3.4.x

### Fixed

- Fixed crash when background location updates aren't enabled

## [3.3.1][] - 2018-03-28

### Changed

- Location is no longer required to download promotion data

### Added

- Added notification when a user selects When-In-Use only permission

## [3.3.0][] - 2018-02-22

### Changed

- Updated to PWCore 3.3.x

### Fixed

- Fixed crash when starting vBLE.

## [3.2.0][] - 2017-12-18

### Added

- Added vBLE Beacon Ranging

## [3.1.3][] - 2017-10-19

### Changed

- Updated PWCore to 3.1.3

## [3.1.2][] - 2017-10-16

### Changed

- Changed the framework to dynamic.
- Used latest logger functionality from PWCore.

### Fixed

- Performed internal fixes.

## [3.1.1][] - 2017-08-14

### Fixed

- Fixed issue with title for broadcast campaigns.

### Changed

- Improved performance.

## [3.1.0][[] - 2017-05-11

### Changed

- Messaging SDK is now called PWEngagement.
