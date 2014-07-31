//
//  DACChooseVehicle.m
//  MilesTracker
//
//  Created by Mac User on 7/22/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACChooseVehicle.h"
#import "TripInputController.h"
#import "Vehicles.h"
#import <Parse/Parse.h>

@interface DACChooseVehicle ()

@property (nonatomic,strong) PFQuery *query;
@property (nonatomic,strong) PFObject *object;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goBackBtn;
@property (nonatomic,strong) Vehicles *vehicle;
@end

@implementation DACChooseVehicle

@synthesize vehicle;

-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = @"Vehicles";
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
    self.query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        self.query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [self.query orderByDescending:@"createdAt"];
    
    return self.query;
}
- (IBAction)goBackToMain:(id)sender {
    
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
    cell.textLabel.text = object[@"Name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 object[@"Model"]];
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
    vehicle = [self.objects objectAtIndex:indexPath.row];
    [Vehicles setCurrentVehicle:vehicle];
    self.onVehicleSelected();
}

@end
