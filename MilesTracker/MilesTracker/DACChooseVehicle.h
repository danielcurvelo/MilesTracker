//
//  DACChooseVehicle.h
//  MilesTracker
//
//  Created by Mac User on 7/22/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import <Parse/Parse.h>

@interface DACChooseVehicle : PFQueryTableViewController

@property (nonatomic,strong) void (^onVehicleSelected)(void);
@end
