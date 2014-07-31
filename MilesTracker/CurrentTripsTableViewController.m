//
//  CurrentTripsTableViewController.m
//  
//
//  Created by Mac User on 6/28/14.
//
//

#import "CurrentTripsTableViewController.h"
#import "DACTripListViewController.h"
#import "DACDetailedFillup.h"
#import "Vehicles.h"
#import "DACFillupCell.h"
#import <Parse/Parse.h>
#import <Analytics/Analytics.h>

@interface CurrentTripsTableViewController ()
@property (nonatomic,strong) PFQuery *query;
@property (nonatomic,strong) PFObject *object;
@property (strong, nonatomic) IBOutlet UILabel *mileageLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *avgMGLabel;
@property (strong,nonatomic) NSArray *milesArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (nonatomic,strong) PFObject *selectedFillup;
@property (readwrite,nonatomic) double MPG;
@property (readwrite,nonatomic) double total;
@property (readwrite,nonatomic) double mileage;
@property (strong, nonatomic) IBOutlet UIView *totalBackground;
@property (strong, nonatomic) IBOutlet UIView *mileageBackground;
@property (strong, nonatomic) IBOutlet UIView *mpgBackground;

@end

static NSString *cellIdentifier = @"DACFillupCell";


@implementation CurrentTripsTableViewController

-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = @"fillup";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    self.navigationController.navigationBar.topItem.title = self.trip[@"TripName" ];

    [self.tableView registerNib:[UINib nibWithNibName:@"DACFillupCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
        self.query = [PFQuery queryWithClassName:self.parseClassName];
        [self.query whereKey:@"Trips"  equalTo:self.trip];
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if (self.objects.count == 0) {
            self.query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        
        [self.query orderByDescending:@"createdAt"];
    
        return self.query;
}

-(void)viewDidAppear:(BOOL)animated
{

    
}

-(void)getCalculations
{
    PFObject *parseTrip = [PFObject objectWithClassName:@"Trips"];
    
    NSDecimalNumber *total = [self.objects valueForKeyPath:@"@sum.Total.doubleValue"];
    self.total = total.doubleValue;
    parseTrip[@"TotalSum"] = [NSString stringWithFormat:@"$%0.1f",self.total];
    
    
    NSDecimalNumber *mileage = [self.objects valueForKeyPath:@"@sum.Miles.doubleValue"];
    self.mileage = mileage.doubleValue;
    parseTrip[@"MileageSum"] = [NSString stringWithFormat:@"$%0.1f",self.mileage];
    
    
    NSDecimalNumber *mpg = [self.objects valueForKeyPath:@"@sum.MPG.doubleValue"];
    self.MPG = mpg.doubleValue;
    self.MPG = self.MPG / self.objects.count;
    parseTrip[@"AvgMPG"] = [NSString stringWithFormat:@"$%0.1f",self.MPG];
    
    [parseTrip saveInBackground];
    
////    self.MPG = [self.objects[@"MPG"] doubleValue];
//    self.total = [self.trip[@"Total"] doubleValue];
//    self.mileage = [self.trip[@"Miles"] doubleValue];
}


-(void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self getCalculations];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.1f",self.total];
    self.totalBackground.layer.borderWidth = 2;
    self.totalBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    self.totalBackground.layer.cornerRadius = 36;
    self.mileageLabel.text = [NSString stringWithFormat:@"%0.1f",self.mileage];
    self.mileageBackground.layer.borderWidth = 2;
    self.mileageBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    self.mileageBackground.layer.cornerRadius = 36;
    if (self.MPG != 0 || self.MPG != NAN) {
        self.avgMGLabel.text = [NSString stringWithFormat:@"%0.1f",self.MPG];
    }else{
        self.avgMGLabel.text = @"0.0";
    }
    self.mpgBackground.layer.borderWidth = 2;
    self.mpgBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    self.mpgBackground.layer.cornerRadius = 36;}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedFillup = self.objects[indexPath.row];
    [self performSegueWithIdentifier:@"tripFillupDetail" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"tripFillupDetail"]){
        
        UINavigationController *navController = [segue destinationViewController];
        DACDetailedFillup *detailController = (DACDetailedFillup *)([navController viewControllers][0]);
        detailController.fillup = self.selectedFillup;
    };
    
}

- (IBAction)goBackToMain:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

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
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
