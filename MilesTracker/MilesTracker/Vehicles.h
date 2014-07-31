//
//  Vehicles.h
//  MilesTracker
//
//  Created by Mac User on 7/12/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Vehicles : PFObject <PFSubclassing>

+ (NSString *)parseClassName;
@property (nonatomic, strong) NSString *cityMPG;
@property (nonatomic, strong) NSString *highwayMPG;
@property (nonatomic, strong) NSString *vehicleMake;
@property (nonatomic, strong) NSString *vehicleModel;
@property (nonatomic, strong) NSString *vehicleYear;
@property (nonatomic, strong) NSString *vehiclePic;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

+ (Vehicles *)currentVehicle;
+ (void)setCurrentVehicle:(Vehicles *)vehicle;

@end
