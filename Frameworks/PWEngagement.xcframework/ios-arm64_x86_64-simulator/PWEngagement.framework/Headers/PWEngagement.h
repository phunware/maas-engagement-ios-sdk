//
//  PWEngagement.h
//  PWEngagement
//
//  Created by Xiangwei Wang on 1/29/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <PWEngagement/PWMEGeozone.h>
#import <PWEngagement/PWMEZoneMessage.h>
#import <PWEngagement/PWMELocalNotification.h>
#import <PWEngagement/PWMEAttributeManager.h>
#import <PWEngagement/PWVBLEManager.h>
#import <PWEngagement/PWBeaconManager.h>
#import <PWEngagement/PWMEDefines.h>

@class Message;

NS_ASSUME_NONNULL_BEGIN

static NSString *const PWEngagementVersion = @"3.14.4";

/**
 The message identifier key which may be included in the notification's userInfo dictionary.
 */
extern NSString *const PWMEMessageIdentifierKey;

/**
 The error key which may be included in the notification's userInfo dictionary.
 */
extern NSString *const PWMENotificationErrorKey;

/**
 The geo zone identifier key which may be included in the notification's userInfo dictionary.
 */
extern NSString *const PWMEGeoZoneIdentifierKey;

/**
 The geo zone identifier array key which may be included in the notification's userInfo dictionary.
 */
extern NSString *const PWMEGeoZoneIdentifierArrayKey;

/**
 * Posted when determines that the device enters a geo zone. The zone identifier is included in the notification's userInfo dictionary with the `PWMEGeoZoneIdentifierKey` key.
 */
extern NSString *const PWMEEnterGeoZoneNotificationKey;

/**
 * Posted when the zone manager determines that the device exits a geo zone. The zone identifier is included in the notification's userInfo dictionary with the `PWMEGeoZoneIdentifierKey` key.
 */
extern NSString *const PWMEExitGeoZoneNotificationKey;

/**
 * Posted when new zones are added to the zone manager's list of available geo zones. The identifiers of the new zones are included in the notification's userInfo dictionary with the 'PWMEGeoZoneIdentifierArrayKey' key.
 */
extern NSString *const PWMEAddGeoZonesNotificationKey;

/**
 * Posted when zones are removed from the zone manager's list of available geo zones. The identifiers of the removed zones are included in the notification's userInfo dictionary with the 'PWMEGeoZoneIdentifierArrayKey' key.
 */
extern NSString *const PWMEDeleteGeoZonesNotificationKey;

/**
 * Posted when the information about one or more geo zones is modified. The identifiers of the modified zones are included in the notification's userInfo dictionary with the 'PWMEGeoZoneIdentifierArrayKey' key.
 */
extern NSString *const PWMEModifyGeoZonesNotificationKey;

/**
 * Posted when mobile engagement service is ready.
 */
extern NSString *const PWMELocationServiceReadyNotificationKey;

/**
 * Posted when determines that the monitored geo zone changes. 
 */
extern NSString *const PWMEMonitoredGeoZoneChangesNotificationKey;

/**
 * The mobile engagement framework is a location and notification based system.
 *
 * The recommended way to start mobile engagement in your application is to place a call
 * to `+startWithMaasAppId:accessKey:completion:` in your `-application:didFinishLaunchingWithOptions:` method.
 *
 * This delay defaults to 1 second in order to generally give the application time to
 * fully finish launching.
 *
 * The framework needs you to forward the following methods from your app delegate:
 *
 * - 'didFinishLaunchingWithOptions:withCompletionHandler:'
 * - 'didRegisterForRemoteNotificationsWithDeviceToken:withNotificationHandler:'
 * - 'didFailToRegisterForRemoteNotificationsWithError:withNotificationHandler:'
 * - 'didReceiveRemoteNotification:fetchCompletionHandler:'
 *
 * You can optionally add a delegate to be informed about errors while initializing the mobile engagement service and to control the display of local notifications to the user.
 **/
@interface PWEngagement : NSObject

/**
 * Starts the mobile engagement service.
 * @param appId You can find your Application ID in the MaaS portal.
 * @param accessKey A unique key that identifies the client making the request. You can find your Access Key in the MaaS portal.
 * @param completion A block that notify mobile engagement service is successfully started or failed to start with reason.
 *      - *param1* error It's nil when it's started successfully, or an error object containing information about a problem that indicates mobile engagement service failed to start.
 */
+ (void)startWithMaasAppId:(NSString *)appId
				 accessKey:(NSString *)accessKey
				completion:(void(^)(NSError * _Nullable error))completion;

/**
 * Stops the mobile engagement service.
 * @param completion A block that notify mobile engagement service is successfully stopped or failed to stop with reason.
 *
 *      - *error* It's nil when it's stopped successfully, or an error object containing information about a problem that indicates mobile engagement service failed to stop.
 */
+ (void)stopWithCompletion:(void(^)(NSError * _Nullable error))completion;

/**
 * @return A list of all available geozones.
 */
+ (NSArray<PWMEGeozone *> * _Nullable)geozones;

/**
 * @return The device identifier used by the mobile engagement service.
 */
+ (NSString *)deviceId;

/**
 * @return The version of the mobile engagement service.
 */
+ (NSString *)version;

/**
 * @return The name of the mobile engagement service.
 */
+ (NSString *)serviceName;

/**
 * Set the block to handle the error when it occurs.
 *
 * @param handler A block that caused mobile engagement service failed.
 *
 *      - *error* An error object containing information about a problem that indicates mobile engagement service failed if the results are retrieved successfully.
 */
+ (void)setErrorHandler:(nullable void(^)(NSError *error))handler;

/**
 * Set the block to handle the local notification which is about to display.
 * @discussion The local notification will be displayed if the block returns `YES`, otherwise, it will not be displayed.
 * @param handler A block that notifies the local notification is about to display, you can control the local notification display and customize the display content.
 *
 *      - *notification* The `PWMELocalNotification` object which contains notification information to display.
 */
+ (void)setLocalNotificationHandler:(nullable BOOL(^)(PWMELocalNotification *notification))handler;

/**
 * Lets the mobile engagement service know that launch process is almost done and the app is almost ready to run.(APNs).
 * @discussion The message deep linking could be fired from the `completionHandler` block. And if returns `YES` in the block, it will prompt an alert tells user how to enable push notification setting when it's disabled, and the prompted message could be configured in localized string file with key `RemindOfEnablePushNotificationSettings`.
 * @param launchOptions A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see Launch Options Keys.
 * @param completionHandler A block that tells if user opens the app by responding to a notification.
 *
 *      - *notification* The notification object if user open the app by responding to a notification from notification tray, otherwise, it's nil.
 */
+ (void)didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions withCompletionHandler:(BOOL(^)(PWMELocalNotification * _Nullable notification))completionHandler;

/**
 * Lets the mobile engagement service know that the app successfully registered with Apple Push Notification service (APNs).
 * @param deviceToken A token that identifies the device to APNs. The token is an opaque data type because that is the form that the provider needs to submit to the APNs servers when it sends a notification to a device. The APNs servers require a binary format for performance reasons. The size of a device token is 32 bytes. Note that the device token is different from the uniqueIdentifier property of UIDevice because, for security and privacy reasons, it must change when the device is wiped.
 */
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/**
 * Lets the mobile engagement service know that the Apple Push Notification service cannot successfully complete the registration process.
 * @param error A NSError that encapsulates information why registration did not succeed. The app can choose to display this information to the user.
 */
+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

/**
 * Lets the mobile engagement service know that a notification arrived while the app was running in the foreground and will be presented.
 *
 * This method must be called at some point within the shared notification center delegate's @b userNotificationCenter:willPresentNotification:withCompletionHandler: method.
 *
 * @remarks Do not call this method if @c UNNotificationPresentationOptionNone is specified to silence the notification completely.
 *
 * @param notification The notification that is about to be presented. This object is provided by the shared notification center delegate.
 * @param completion A block that returns the message associated with the notification, or an error.
 */
+ (void)willPresentNotification:(UNNotification *)notification withCompletion:(void(^)(Message * _Nullable message, NSError * _Nullable error))completion;

/**
 * Lets the mobile engagement service know that a user has responded to a notification which arrived while the app was running in the foreground.
 *
 * This method must be called at some point within the shared notification center delegate's @b userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: method.
 *
 * @param response The user’s response to the notification. This object is provided by the shared notification center delegate.
 * @param completion A block that returns the message associated with the original notification, or an error.
 */
+ (void)didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletion:(void(^)(Message * _Nullable message, NSError * _Nullable error))completion;

/**
 * Lets the mobile engagement service know that a notification arrived.
 *
 * This method must be called at some point within your app delegate's  @b application:didReceiveRemoteNotification:fetchCompletionHandler: method.
 *
 * @param userInfo The user information dictionary associated with the notification. This object is provided by your app delegate.
 * @param completion A block that returns the message associated with the notification, or an error.
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo withCompletion:(nullable void(^)(Message * _Nullable message, NSError * _Nullable error))completion;

/**
 * Set the static identifier to be registered with the current device.
 * @discussion This registers the selected static identifier with the device identifier.
 * @param staticIdentifier The identifier that will be associated with the current device identifier.
 * @param completion The block that notifies the user when static identifier registration is complete, and whether or not there was an error on the registration request.
 */
+ (void)setStaticIdentifier:(NSString *)staticIdentifier completion:(void(^)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
