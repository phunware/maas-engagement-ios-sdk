//
//  MaaSLocationDefines.h
//  MaaSLocation
//
//  Created by Carl Zornes on 6/27/14.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;
 
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



