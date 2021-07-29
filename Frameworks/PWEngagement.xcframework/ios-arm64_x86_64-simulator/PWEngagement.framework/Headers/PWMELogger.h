//
//  PWMELogger.h
//  PWEngagement
//
//  Created by Alejandro Mendez on 3/6/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <PWCore/PWLogger.h>
#import <PWEngagement/PWEngagement.h>

#import "PWMEDefines.h"

static NSString* kPWMELogCategoryKey = @"category";
static NSString* kPWMELogCategoryNetworking = @"Network";
static NSString* kPWMELogCategoryPersistence = @"Persistence";
static NSString* kPWMELogCategoryZones = @"Zones";
static NSString* kPWMELogCategoryLocation = @"Location";
static NSString* kPWMELogCategoryGeneral = @"General";
static NSString* kPWMELogCategoryRemoteNotifications = @"Remote Notifications";
static NSString* kPWMELogCategoryMessage = @"Message";
static NSString* kPWMELogCategoryBeacon = @"Beacon";
static NSString* kPWMELogCategoryAttributes = @"Attributes";

static NSString* kPWMELogCategoryAnalyticsGeneral = @"Analytics General";
static NSString* kPWMELogCategoryAnalyticsNetworking = @"Analytics Networking";
static NSString* kPWMELogCategoryAnalyticsPersistence = @"Analytics Persistence";

static NSString* kPWMELogEventKey = @"event";
static NSString* kPWMELogErrorKey = @"error";

#define PWMELogError(message, ...)   PWLogError([PWEngagement serviceName],message, __VA_ARGS__)
#define PWMELogWarning(message, ...)   PWLogWarning([PWEngagement serviceName],message, __VA_ARGS__)
#define PWMELogInfo(message, ...)   PWLogInfo([PWEngagement serviceName],message, __VA_ARGS__)
#define PWMELogDebug(message, ...)   PWLogDebug([PWEngagement serviceName],message, __VA_ARGS__)

/**
 * Handles the state of the loggers
 */
@interface PWMELogger : NSObject

/**
 * Add the loggers if the current configuration is development
 */
+ (void)enableLogging;

@end




