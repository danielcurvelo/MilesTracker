//
//  Vehicles.m
//  MilesTracker
//
//  Created by Mac User on 7/12/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "Vehicles.h"
#import "DACVehicleController.h"
#import <Parse/PFObject+Subclass.h>

@implementation Vehicles

+ (NSString *)parseClassName {
    return @"Vehicles";
}


static Vehicles *currentVehicle;
+ (Vehicles *)currentVehicle {
    return currentVehicle;
}

+ (void)setCurrentVehicle:(Vehicles *)vehicle {
    currentVehicle = vehicle;
}


- (void)updateWithDictionary:(NSDictionary *)dictionary {
    
        self.cityMPG = dictionary[@"MPG"][@"city"];
        self.highwayMPG = dictionary[@"MPG"][@"highway"];
        self.vehicleMake = dictionary[@"make"][@"name"];
        self.vehicleModel = dictionary[@"model"][@"name"];
        self.vehicleYear = [NSString stringWithFormat:@"%@", dictionary[@"years"][0][@"year"]];        
}
//2G1FC3D33C9165616
@end
