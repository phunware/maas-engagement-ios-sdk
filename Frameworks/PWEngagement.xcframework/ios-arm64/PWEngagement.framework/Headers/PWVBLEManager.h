//
//  PWVBLEManager.h
//  PWBeaconMessaging
//
//  Created by Chesley Stephens on 6/23/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWEngagement/PWBeaconManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWVBLEManager : NSObject <PWBeaconManager>

@end

@protocol PWVBLEBeaconManagerProvider <NSObject>

+ (void)createVBLEBeaconManagerProviderWithSDKToken:(NSString *)sdkToken completion:(void(^)(PWVBLEManager * _Nullable manager, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
