//
//  NetworkController.m
//  MilesTracker
//
//  Created by Mac User on 6/28/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

+ (AFHTTPSessionManager *)api {
    static AFHTTPSessionManager *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.edmunds.com"]];
        api.responseSerializer = [AFJSONResponseSerializer serializer];
        api.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return api;
}

+ (NSDictionary *)parameters {
    
    NSMutableDictionary *parametersWithKey = [NSMutableDictionary new];
    [parametersWithKey setObject:@"uf84eggkxebcyqzxpzzwbsup" forKey:@"api_key"];
    [parametersWithKey setObject:@"json" forKey:@"fmt"];
    
    return [parametersWithKey copy];
}

@end
