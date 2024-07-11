//
//  MaaSLocationDefines.h
//  MaaSLocation
//
//  Created by Carl Zornes on 6/27/14.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
 
typedef enum : NSUInteger {
    PWMEErrorInvalidCode,
    PWMEErrorNotFoundCode,
    PWMEErrorDuplicateCode,
    PWMEErrorInvalidOperation,
    PWMEErrorMissingConfiguration
} PWMobileEngagmentErrorCode;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#pragma mark - Environment
extern NSString *const kEnvironmentDevelopment;
extern NSString *const kEnvironmentStage;
extern NSString *const kEnvironmentProduction;

#pragma mark - API


extern NSString *const kPWEngagementServerInfoKey;
extern NSString *const kPWEngagementApplicationInfoKey;

#pragma mark - Monitoring region limits

extern NSString *const kPWMEMonitoringRegionPrefix;
extern NSString *const kPWMEUpdateRegionIdentifier;

#pragma mark - Common

extern NSString *const kPWMEServiceName;


#pragma mark - Error code/message

extern NSString *const PWMEErrorDomain;

#pragma mark - Pending Deregistration Keys

extern NSString *const PWMEPendingDeregistrationTokenKey;
extern NSString *const PWMEPendingDeregistrationConfigurationKey;

#pragma mark - Persistence

extern NSString *const kPWMEDatabaseTagSeparator;

#pragma mark - Logging

extern NSString * const kPWMELogCategoryKey;
extern NSString * const kPWMELogCategoryNetworking;
extern NSString * const kPWMELogCategoryPersistence;
extern NSString * const kPWMELogCategoryZones;
extern NSString * const kPWMELogCategoryLocation;
extern NSString * const kPWMELogCategoryGeneral;
extern NSString * const kPWMELogCategoryRemoteNotifications;
extern NSString * const kPWMELogCategoryMessage;
extern NSString * const kPWMELogCategoryBeacon;
extern NSString * const kPWMELogCategoryAttributes;
extern NSString * const kPWMELogCategoryAnalyticsGeneral;
extern NSString * const kPWMELogCategoryAnalyticsNetworking;
extern NSString * const kPWMELogCategoryAnalyticsPersistence;
extern NSString * const kPWMELogEventKey;
extern NSString * const kPWMELogErrorKey;

/**
 * Defines some common convenience methods related to applications constants.
 */
@interface PWMEDefines : NSObject

#pragma mark - Persistence

/**
 * Gets the path to the mobile engagement database.
 * @return A string containing the path to the mobile engagement database.
 */
+ (NSString*)pathForEngagementDatabase;

@end
