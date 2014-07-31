//
//  DACVehicleController.h
//  MilesTracker
//
//  Created by Mac User on 7/12/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicles.h"

@interface DACVehicleController : NSObject

+ (DACVehicleController *)sharedInstance;

- (void)searchForVehicles:(NSString *)vinString completion:(void (^)(BOOL success, Vehicles *vehicle))completion;

@property (nonatomic, strong) Vehicles *resultVehicle;

@end
