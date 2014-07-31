//
//  NetworkController.h
//  MilesTracker
//
//  Created by Mac User on 6/28/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface NetworkController : NSObject

+ (AFHTTPSessionManager *)api;

+ (NSDictionary *)parameters;

@end
