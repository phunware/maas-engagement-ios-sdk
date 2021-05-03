//
//  PWBeaconManager.h
//  PWEngagement
//
//  Created by Chesley Stephens on 6/23/17.
//  Copyright © 2017 Phunware. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol PWBeaconManagerDelegate;

@class CLBeaconRegion;
@class PWBeacon;
@class PWBeaconBundle;

@protocol PWBeaconManager <NSObject>

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
- (void)updateStateForBeaconRegion:(CLBeaconRegion *)region;

@property (nonatomic, weak) id<PWBeaconManagerDelegate> beaconDelegate;

- (void)startMonitoringBeaconBundle:(PWBeaconBundle *)beaconBundle;
- (void)stopMonitoringBeaconBundle:(PWBeaconBundle *)beaconBundle completion:(void(^)(NSError *error))completion;

@end

@protocol PWBeaconManagerDelegate <NSObject>

- (void)beaconManager:(id<PWBeaconManager>)manager didRangeBeacons:(NSArray<PWBeacon *> *)beacons;

@end
