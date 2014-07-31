//
//  DACVehicleController.m
//  MilesTracker
//
//  Created by Mac User on 7/12/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACVehicleController.h"
#import "Vehicles.h"
#import "NetworkController.h"

@interface DACVehicleController ()

@end

@implementation DACVehicleController

+ (DACVehicleController *)sharedInstance {
    static DACVehicleController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DACVehicleController new];
    });
    return sharedInstance;
}

-(void)searchForVehicles:(NSString *)vinString completion:(void (^)(BOOL, Vehicles *))completion{
    NSString *path =[NSString stringWithFormat:@"/api/vehicle/v2/vins/%@", vinString];
    [[NetworkController api] GET:path parameters:[NetworkController parameters] success:^(NSURLSessionDataTask *task, id responseObject) {
        self.resultVehicle = [Vehicles object];
        [self.resultVehicle updateWithDictionary:responseObject];
        [self.resultVehicle saveEventually];
        completion(YES, self.resultVehicle);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, nil);
    }];
    
}


@end
