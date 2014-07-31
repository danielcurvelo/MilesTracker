//
//  DACFillupCell.h
//  
//
//  Created by Mac User on 7/22/14.
//
//

#import <Parse/Parse.h>

@interface DACFillupCell : PFTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *fillupNameLabel;
@property (strong, nonatomic) IBOutlet UIView *gasBackground;
@property (strong, nonatomic) IBOutlet UIView *mpgBackground;
@property (strong, nonatomic) IBOutlet UILabel *mpgLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
