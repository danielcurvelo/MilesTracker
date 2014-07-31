//
//  DACChooseTripController.m
//  MilesTracker
//
//  Created by Mac User on 7/17/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACChooseTripController.h"
#import "TripInputController.h"
#import "Vehicles.h"
#import <Parse/Parse.h>

@interface DACChooseTripController ()

@property (nonatomic,strong) PFQuery *query;
@property (nonatomic,strong) PFObject *object;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
@property (nonatomic,strong) PFObject *trip;
@end

@implementation DACChooseTripController

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
        return nil;
    }
}
- (IBAction)goBackButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    
    
    static NSString *cellIdentifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                 reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = object[@"TripName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 object[@"Motive"]];
    cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:204/255.0f alpha:1.0];
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.1)];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    trip = [self.objects objectAtIndex:indexPath.row];
    self.onTripSelected(trip);
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
