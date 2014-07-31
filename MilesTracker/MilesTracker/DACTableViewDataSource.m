//
//  DACTableViewDataSource.m
//  MilesTracker
//
//  Created by Mac User on 7/12/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACTableViewDataSource.h"
#import "DACVehicleController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSString * const cellReuseKey = @"cell";

@implementation DACTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    //return [[DACVehicleController sharedInstance].resultVehicles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseKey];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseKey];
    }
    
//    NSDictionary *vehicle = [DACVehicleController sharedInstance].resultVehicles[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[vehicle objectForKey:@"make"] objectForKey:@"name"]];;
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [vehicle objectForKey:@"make"] vehicle objectForKey:@"name"], vehicle[@"vote_average"]];
//    
//    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w92/%@", vehicle[@"poster_path"]]]];
    
    return cell;
}

@end
