//
//  MistBeaconProvider.h
//  MistBeaconProvider
//
//  Created by Troy Stump on 9/15/20.
//  Copyright © 2020 Phunware. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<MistBeaconProvider/PWMistBeaconManager+Provider.h>)
#import <MistBeaconProvider/PWMistBeaconManager+Provider.h>
#else
#import "PWMistBeaconManager+Provider.h"
#endif

static NSString * const MistBeaconProviderVersion = @"3.10.0";
