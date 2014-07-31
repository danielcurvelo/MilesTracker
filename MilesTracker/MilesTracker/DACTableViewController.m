//
//  DACTableViewController.m
//  MilesTracker
//
//  Created by Mac User on 6/28/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACTableViewController.h"
#import "Vehicles.h"
#import <Parse/Parse.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import "DACTripListViewController.h"

@interface DACTableViewController ()
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *nameInput;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *motiveInput;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
@property (strong,nonatomic) PFObject *vehicle;

@end

@implementation DACTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goBackButtonPressed:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.createButton.layer.cornerRadius = 8;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)createTrip:(id)sender {
    
    if(self.nameInput.text.length >0){
    PFObject *Object = [PFObject objectWithClassName:@"Trips"];
    [Object setObject:[Vehicles currentVehicle] forKey:@"Vehicles"];
        
    [Object setObject:[Vehicles currentVehicle] forKey:@"Trips"];
        
    [Object setObject:self.nameInput.text forKey:@"TripName"];
    [Vehicles currentVehicle][@"TripName"] = self.nameInput.text;
        
    [Object setObject:self.motiveInput.text forKey:@"Motive"];
    [Vehicles currentVehicle][@"Motive"] = self.motiveInput.text;


    self.nameInput.text = @"";
    self.motiveInput.text = @"";
    
    [self.motiveInput resignFirstResponder];
    
    [[Vehicles currentVehicle] saveInBackground];
    [Object saveInBackground];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    }else if (self.nameInput.text.length < 1){
        UIAlertView *inputSentMessage = [[UIAlertView alloc]initWithTitle:@"Name Needed" message:@"You need to assign a name to this trip." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [inputSentMessage show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
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
