//
//  DACFillupList.m
//  
//
//  Created by Mac User on 7/16/14.
//
//

#import "DACFillupList.h"
#import "DACChooseVehicle.h"
#import "DACCarInfoViewController.h"
#import <MSCMoreOptionTableViewCell/MSCMoreOptionTableViewCell.h>
#import "TripInputController.h"
#import "DACDetailedFillup.h"
#import "Vehicles.h"
#import "DACFillupCell.h"
#import <Parse/Parse.h>


@interface DACFillupList () <MSCMoreOptionTableViewCellDelegate>
@property (nonatomic,strong) PFQuery *query;
@property (nonatomic,strong) PFObject *object;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PFObject *selectedFillup;
@end

static NSString *cellIdentifier = @"DACFillupCell";

@implementation DACFillupList

-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = @"fillup";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 50;
    }
    return self;
}

- (PFQuery *)queryForTable {
    [self.tableView registerNib:[UINib nibWithNibName:@"DACFillupCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
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

//-(void)viewDidAppear:(BOOL)animated
//{
//    [self viewDidAppear:YES];
//    [self loadObjects];
//}

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

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"fillupDetail"]) {
//        UINavigationController *navController = [segue destinationViewController];
//        DACDetailedFillup *currentFillup = (DACDetailedFillup *)([navController viewControllers][0]);
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    DACFillupCell *cell = (DACFillupCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.gasBackground.layer.cornerRadius = 8;
    cell.mpgBackground.layer.cornerRadius = 8;
    cell.mpgBackground.layer.borderWidth = 1;
    cell.mpgBackground.layer.borderColor = [UIColor orangeColor].CGColor;

//    if (!cell) {
//        cell = [[MSCMoreOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
//                                                 reuseIdentifier:cellIdentifier];
//    }
    NSDate *logDate = [object createdAt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d"];
    [timeFormat setDateFormat:@"h:mm a"];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", [timeFormat stringFromDate:logDate]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:logDate]];
    cell.fillupNameLabel.text = [NSString stringWithFormat:@"$%@", object[@"Total"]];
    cell.mpgLabel.text = [NSString stringWithFormat:@"%@ mpg", object[@"MPG"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@/gal", object[@"Price"]];
    cell.backgroundColor =[UIColor colorWithRed:17/255.0f green:69/255.0f blue:114/255.0f alpha:1.0];
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.1)];
    separatorLineView.backgroundColor = [UIColor blackColor]; // set color as you want.
    [cell.contentView addSubview:separatorLineView];
    return cell;
        [self loadObjects];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedFillup = self.objects[indexPath.row];
    [self performSegueWithIdentifier:@"fillupDetail" sender:self];    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"fillupDetail"]){
        
            UINavigationController *navController = [segue destinationViewController];
            DACDetailedFillup *detailController = (DACDetailedFillup *)([navController viewControllers][0]);
        detailController.fillup = self.selectedFillup;
                        };

}


-(void)tableView:(UITableView *)tableView moreOptionButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIColor *)tableView:(UITableView *)tableView backgroundColorForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIColor colorWithWhite:1 alpha:1];
}

- (UIColor *)tableView:(UITableView *)tableView backgroundColorForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [UIColor redColor];
}


@end
