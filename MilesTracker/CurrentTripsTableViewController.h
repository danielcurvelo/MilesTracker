//
//  CurrentTripsTableViewController.h
//  
//
//  Created by Mac User on 6/28/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CurrentTripsTableViewController : PFQueryTableViewController

@property (nonatomic,strong) PFObject* trip;

@end
