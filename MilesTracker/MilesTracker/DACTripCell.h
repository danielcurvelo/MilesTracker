//
//  DACTripCell.h
//  MilesTracker
//
//  Created by Mac User on 7/30/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DACTripCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tripNameLabel;
@property (strong, nonatomic) IBOutlet UIView *imageTripBackground;
@property (strong, nonatomic) IBOutlet UILabel *motiveTripLabel;
@property (strong, nonatomic) IBOutlet UIView *nameMotiveBackground;

@end
