//
//  DACTripListViewController.m
//  MilesTracker
//
//  Created by Mac User on 6/28/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACTripListViewController.h"
#import "CurrentTripsTableViewController.h"
#import "Vehicles.h"
#import "DACTripCell.h"
#import <MSCMoreOptionTableViewCell/MSCMoreOptionTableViewCell.h>

@interface DACTripListViewController () <MSCMoreOptionTableViewCellDelegate>
@property (nonatomic,strong) PFQuery *query;
@property (nonatomic,strong) PFObject *object;
@property (nonatomic,strong) PFObject *trip;

@end

static NSString *cellIdentifier = @"DACTripCell";

@implementation DACTripListViewController
@synthesize trip;

-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = @"Trips";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;

    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadObjects];
}

- (PFQuery *)queryForTable {
    [self.tableView registerNib:[UINib nibWithNibName:@"DACTripCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    self.query = [PFQuery queryWithClassName:self.parseClassName];
    if ([Vehicles currentVehicle] != NULL) {
        
        self.query = [PFQuery queryWithClassName:self.parseClassName];
        [self.query whereKey:@"Vehicles"  equalTo:[Vehicles currentVehicle]];
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if (self.objects.count == 0) {
            self.query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        
        [self.query orderByDescending:@"createdAt"];
        
        return self.query;
    }else{
        
        UIAlertView *noVehicleSelected = [[UIAlertView alloc]initWithTitle:@"No Vehicle Selected" message:@"Please select a vehicle on the main tab." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [noVehicleSelected show];
        return nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        UITabBarController *vehicleController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
        [self presentViewController:vehicleController animated:YES completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
//    self.query = [PFQuery queryWithClassName:@"fillup"];
//    [self.query whereKey:@"Vehicles"  equalTo:[Vehicles currentVehicle]];
//    [self.query whereKey:@"Trips"  equalTo:[Vehicles currentVehicle]];
   
    DACTripCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DACTripCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    cell.imageTripBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    cell.imageTripBackground.layer.borderWidth = 1;
    cell.imageTripBackground.layer.cornerRadius = 20;
    cell.tripNameLabel.text = object[@"TripName"];
    cell.motiveTripLabel.text = object[@"Motive"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 object[@"Motive"]];
    self.tripTitle = object[@"TripName"];
    
    cell.backgroundColor =[UIColor colorWithRed:17/255.0f green:69/255.0f blue:114/255.0f alpha:1.0];
    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.1)];
    separatorLineView.backgroundColor = [UIColor blackColor]; // set color as you want.
    [cell.contentView addSubview:separatorLineView];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadObjects];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"tripDetail"]) {
        UINavigationController *navController = [segue destinationViewController];
        CurrentTripsTableViewController *currentTripController = (CurrentTripsTableViewController *)([navController viewControllers][0]);
        currentTripController.trip = trip;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  //  dispatch_async(dispatch_get_main_queue(), ^{});
    trip = [self.objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"tripDetail" sender:[self.tableView cellForRowAtIndexPath:indexPath]];

}

-(void)tableView:(UITableView *)tableView moreOptionButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(UIColor *)tableView:(UITableView *)tableView backgroundColorForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIColor colorWithWhite:0.4 alpha:0];
}

- (UIColor *)tableView:(UITableView *)tableView backgroundColorForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [UIColor redColor];
}



@end
