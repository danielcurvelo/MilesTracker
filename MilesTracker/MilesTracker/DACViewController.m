//
//  DACViewController.m
//  MilesTracker
//
//  Created by Mac User on 6/26/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACViewController.h"
#import <Parse/Parse.h>
#import "TripInputController.h"
#import "DACTripListViewController.h"

@interface DACViewController ()

@property (nonatomic,strong) UITableViewCell *cell;
@property (nonatomic,strong) NSArray *tripArray;
@property (strong, nonatomic) IBOutlet UITableView *tripTable;
@end

@implementation DACViewController

@synthesize tripArray, cell;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tripTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tripTable];
    
    self.tripTable.dataSource = self;
    self.tripTable.delegate = self;
    
    [self.tripTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)retrieveParse:(NSArray *)objects
{
    PFQuery *query = [PFQuery queryWithClassName:@"Trips"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            tripArray = [[NSArray alloc]initWithArray:objects];
        }
        else{
            NSLog(@"You've got the Wrong Class");
        }
        [self.tripTable reloadData];
        }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
//    return [tripArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    PFObject *tripName = [tripArray objectAtIndex:indexPath.row];
    NSLog(@"%@",[tripName objectForKey:@"Motive"]);
    cell.textLabel.text = [tripName objectForKey:@"Name"];
    
    return cell;

}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Title of the Cell";
//}

@end
