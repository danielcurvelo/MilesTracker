//
//  DACDetailedFillup.m
//  MilesTracker
//
//  Created by Mac User on 7/19/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACDetailedFillup.h"
#import "CurrentTripsTableViewController.h"
#import "MyAnnotation.h"
#import <MapKit/MapKit.h>

@interface DACDetailedFillup ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
//@property (nonatomic, strong) PFObject *fillup;
@property (strong, nonatomic) IBOutlet UIView *milesBackground;
@property (strong, nonatomic) IBOutlet UIView *totalBackground;
@property (strong, nonatomic) IBOutlet UIView *gallonsBackground;
@property (strong, nonatomic) IBOutlet UILabel *milesLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPurchase;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *mpgLabel;
@end

@implementation DACDetailedFillup

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.milesLabel.layer.borderWidth = 2;
    self.milesLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    self.milesLabel.layer.cornerRadius = 39;

    self.totalPurchase.layer.borderWidth = 2;
    self.totalPurchase.layer.borderColor = [UIColor orangeColor].CGColor;
    self.totalPurchase.layer.cornerRadius = 39;

    self.mpgLabel.layer.borderWidth = 2;
    self.mpgLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    self.mpgLabel.layer.cornerRadius = 39;

    self.milesLabel.text = [NSString stringWithFormat:@"%@",self.fillup[@"Miles"] ];
    self.totalPurchase.text = [NSString stringWithFormat:@"$%@",self.fillup[@"Total"]];
    self.mpgLabel.text = self.fillup[@"Gallons"];
    
    self.milesBackground.layer.cornerRadius = 8;
    self.gallonsBackground.layer.cornerRadius = 8;
    self.totalBackground.layer.cornerRadius = 8;
    
    NSDate *logDate = [self.fillup createdAt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d"];
    [timeFormat setDateFormat:@"h:mm a"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [timeFormat stringFromDate:logDate]];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:logDate]];

    
    CLLocationCoordinate2D test = CLLocationCoordinate2DMake(40.435377, -111.890774);
    MyAnnotation *annote2 = [[MyAnnotation alloc] initWithTitle:@"Adobe Systems" location:test];
    [self.mapView addAnnotation:annote2];
    
}

- (IBAction)goBackButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
