//
//  TripInputController.m
//  
//
//  Created by Mac User on 6/26/14.
//
//

#import "TripInputController.h"
#import "DACChooseTripController.h"
#import "DACChooseVehicle.h"
#import "Vehicles.h"
#import "MyAnnotation.h"
#import <Parse/Parse.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import <MapKit/MapKit.h>

@interface TripInputController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *MilesInput;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *totalInput;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *gallonsInput;
@property (strong, nonatomic) IBOutlet UIButton *chooseATripBtn;
@property (nonatomic, strong) PFObject *trip;
@property (nonatomic, strong) PFObject *vehicle;
@property (nonatomic, strong) PFObject *fillup;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutlet UIImageView *receiptImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraBtn;
@property (strong, nonatomic) IBOutlet UIView *milesBackground;
@property (strong, nonatomic) IBOutlet UIView *gallonsBackground;
@property (strong, nonatomic) IBOutlet UIView *totalBackground;
@property (strong, nonatomic) IBOutlet UILabel *milesLabel;
@property (strong, nonatomic) IBOutlet UILabel *gallonsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (readwrite,nonatomic) double gallons;
@property (readwrite,nonatomic) double total;
@property (readwrite,nonatomic) double mileage;
@property (strong, nonatomic) IBOutlet UILabel *perGallonLabel;
@property (strong, nonatomic) IBOutlet UITextField *OdometerInput;
@property (readwrite,nonatomic) double milesFromOdometer;
@property (strong,nonatomic) NSMutableArray *milesArray;
@property (strong,nonatomic) NSMutableArray *gallonsArray;
@property (strong, nonatomic) IBOutlet UIButton *captureBtnInImage;
@property (strong, nonatomic) IBOutlet UILabel *currentOdometer;
@property (strong, nonatomic) IBOutlet UIView *odometerBackground;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong,nonatomic) UIImage *image;

@end

#define METERS_PER_MILE 1609.344

@implementation TripInputController{
    CLLocationManager *locationManager;
}

@synthesize fillup;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getOdometerCalculations];
    
//    self.perGallonLabel.layer.borderWidth = 2;
//    self.perGallonLabel.layer.borderColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:204/255.0f alpha:1.0].CGColor;
//    self.perGallonLabel.layer.cornerRadius = 8;

    self.milesBackground.layer.cornerRadius = 36;
    self.milesBackground.layer.borderWidth = 2;
    self.milesBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.gallonsBackground.layer.cornerRadius = 36;
    self.gallonsBackground.layer.borderWidth = 2;
    self.gallonsBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.totalBackground.layer.cornerRadius = 36;
    self.totalBackground.layer.borderWidth = 2;
    self.totalBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.milesLabel.layer.cornerRadius = 8;
    self.gallonsLabel.layer.cornerRadius = 8;
    self.totalLabel.layer.cornerRadius = 8;
    self.receiptImageView.layer.cornerRadius = 8;
    self.receiptImageView.layer.borderWidth = 2;
    self.receiptImageView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.chooseATripBtn.layer.cornerRadius = 8;
    self.odometerBackground.layer.borderWidth = 1;
    self.odometerBackground.layer.borderColor =[UIColor orangeColor].CGColor;
    self.odometerBackground.layer.cornerRadius = 8;
    self.MilesInput.delegate = self;
    self.totalInput.delegate = self;
    
    self.submitBtn.layer.cornerRadius = 8;
    self.cancelBtn.layer.cornerRadius = 8;
    
    self.currentOdometer.text = [NSString stringWithFormat:@"Current Odometer %@ miles",[Vehicles currentVehicle][@"Odometer"]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}


- (IBAction)gallonsTextField:(id)sender {
    self.gallons = [[self.gallonsInput text] doubleValue];
//    self.price = [[self.priceInput text] doubleValue];
  
}

- (IBAction)totalTextField:(id)sender {
    
    self.total = [[self.totalInput text] doubleValue];
    
}

- (IBAction)mileageTextField:(id)sender {
    self.mileage = [[self.MilesInput text] doubleValue];
}

-(void)getOdometerCalculations
{
    PFQuery *query = [PFQuery queryWithClassName:@"Vehicles"];
    [query getObjectInBackgroundWithId:[Vehicles currentVehicle].objectId block:^(PFObject *vehicleData, NSError *error) {
        self.milesArray =[[NSMutableArray alloc] initWithObjects:[Vehicles currentVehicle][@"Odometer"],nil];
        self.gallonsArray =[[NSMutableArray alloc] initWithObjects:[Vehicles currentVehicle][@"Gallons"],nil];
        self.mileage = [[self.MilesInput text] doubleValue];
    }];
}

- (IBAction)getMileageFromOldOdometer:(id)sender {
    [self getOdometerCalculations];
    if ([self.milesArray objectAtIndex:0] != 0) {
    self.MilesInput.text = [NSString stringWithFormat:@"%0.1f", [[sender text]doubleValue] - [[self.milesArray objectAtIndex:0]doubleValue]] ;
    }else{
        self.MilesInput.text = self.OdometerInput.text;
    }
}

- (IBAction)captureReceipt:(id)sender {

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.receiptImageView.image = self.image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"tripChooser"]) {
        UINavigationController *navController = [segue destinationViewController];
        DACChooseTripController *TripController = (DACChooseTripController *)([navController viewControllers][0]);
        [TripController setOnTripSelected:^(PFObject *trip) {
            self.trip = trip;
            [self dismissViewControllerAnimated:YES completion:nil];
//            self.tripLabel.text = trip[@"TripName"];
            [self.chooseATripBtn setTitle:trip[@"TripName"] forState:UIControlStateNormal];
        }];
    }
}

- (IBAction)resignKeyboardWithTap:(id)sender {
    [self.MilesInput resignFirstResponder];
    [self.totalInput resignFirstResponder];
    [self.gallonsInput resignFirstResponder];
    [self.OdometerInput resignFirstResponder];
    
    if (self.gallonsInput.text.length > 0 && self.totalInput.text.length > 0){
    self.Price = self.total / self.gallons;
    self.perGallonLabel.text = [NSString stringWithFormat:@"Price per Gallons:$%0.2f",self.Price];
    }else{
        self.perGallonLabel.text = @"";
    }
}

- (IBAction)sendInputs:(id)sender {
    [self getOdometerCalculations];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    if (self.trip){
    fillup = [PFObject objectWithClassName:@"fillup"];
//    fillup.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [fillup setObject:[Vehicles currentVehicle] forKey:@"Vehicles"];
    NSData *imageData = UIImagePNGRepresentation(self.image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    
        if(self.image){
            fillup[@"imageFile"] = imageFile;
        }
    fillup[@"Gallons"] = self.gallonsInput.text;
    self.trip[@"Gallons"] = self.gallonsInput.text;
    [Vehicles currentVehicle][@"Gallons"] = self.gallonsInput.text;
    fillup[@"Total"] = self.totalInput.text;
    self.trip[@"Total"] = self.totalInput.text;
    [Vehicles currentVehicle][@"Total"] = self.totalInput.text;
    fillup[@"Miles"] = self.MilesInput.text;
    self.trip[@"Miles"] = self.MilesInput.text;
    [Vehicles currentVehicle][@"Miles"] = self.MilesInput.text;

//    fillup[@"Receipt"] =self.receiptImageView.image;
//    self.trip[@"Receipt"] =self.receiptImageView.image;
        
    self.MilesInput.text =@"";
    self.totalInput.text =@"";
    self.gallonsInput.text =@"";
    
        self.MPG = self.mileage / self.gallons;
        self.Price = self.total / self.gallons;
        
        self.perGallonLabel.text = [NSString stringWithFormat:@"$%0.2f per Gallon",self.Price];

        if (self.OdometerInput.text.length > 0){
        fillup[@"Odometer"] = [NSString stringWithFormat:@"%@", self.OdometerInput.text];
        self.trip[@"Odometer"] = [NSString stringWithFormat:@"%@", self.OdometerInput.text];
        [Vehicles currentVehicle][@"Odometer"] = [NSString stringWithFormat:@"%@", self.OdometerInput.text];
        }
        else if(self.OdometerInput.text.length < 1 && self.MilesInput.text.length > 0)
        {
            fillup[@"Odometer"] = [NSString stringWithFormat:@"%0.1f", [[self.MilesInput text] doubleValue] + [[self.milesArray objectAtIndex:0]doubleValue]];
            self.trip[@"Odometer"] = [NSString stringWithFormat:@"%0.1f", [[self.MilesInput text] doubleValue] + [[self.milesArray objectAtIndex:0]doubleValue]];
            [Vehicles currentVehicle][@"Odometer"] = [NSString stringWithFormat:@"%0.1f", [[self.MilesInput text] doubleValue] + [[self.milesArray objectAtIndex:0]doubleValue]];
    
        }
        
        fillup[@"MPG"] = [NSString stringWithFormat:@"%0.1f", self.MPG];
        self.trip[@"MPG"] = [NSString stringWithFormat:@"%0.1f", self.MPG];
        [Vehicles currentVehicle][@"MPG"] = [NSString stringWithFormat:@"%0.1f", self.MPG];
        fillup[@"Price"] = [NSString stringWithFormat:@"%0.2f", self.Price];
        self.trip[@"Price"] = [NSString stringWithFormat:@"%0.2f", self.Price];
        [Vehicles currentVehicle][@"Price"] = [NSString stringWithFormat:@"%0.2f", self.Price];
        NSLog(@"The Price is: %0.2f",self.Price);
        
        
    [fillup saveInBackground];
    [self.trip saveInBackground];
    [[Vehicles currentVehicle] saveInBackground];
        
    }else{
        
    fillup = [PFObject objectWithClassName:@"fillup"];
    [fillup setObject:[Vehicles currentVehicle] forKey:@"Vehicles"];
        
    fillup[@"Gallons"] = self.gallonsInput.text;
    [Vehicles currentVehicle][@"Gallons"] = self.gallonsInput.text;
    fillup[@"Total"] = self.totalInput.text;
    [Vehicles currentVehicle][@"Total"] = self.totalInput.text;
        
    fillup[@"Miles"] = self.MilesInput.text;
    [Vehicles currentVehicle][@"Miles"] = self.MilesInput.text;
        
        self.MilesInput.text =@"";
        self.totalInput.text =@"";
        self.gallonsInput.text =@"";
        
        if (self.milesArray.count > 0){
        self.MPG = self.mileage / self.gallons;}
        self.Price = self.total / self.gallons;
        
        self.perGallonLabel.text = [NSString stringWithFormat:@"$%0.2f per Gallon",self.Price];
        
        if (self.OdometerInput.text.length > 0){
            fillup[@"Odometer"] = [NSString stringWithFormat:@"%@", self.OdometerInput.text];
            self.trip[@"Odometer"] = [NSString stringWithFormat:@"%@", self.OdometerInput.text];
            [Vehicles currentVehicle][@"Odometer"] = [NSString stringWithFormat:@"%@", self.OdometerInput.text];
        }
        else if(self.OdometerInput.text.length == 0 && self.MilesInput.text.length > 0)
        {
            fillup[@"Odometer"] = [NSString stringWithFormat:@"%0.1f", [[self.MilesInput text] doubleValue] + [[self.milesArray objectAtIndex:0]doubleValue]];
            self.trip[@"Odometer"] = [NSString stringWithFormat:@"%0.1f", [[self.MilesInput text] doubleValue] + [[self.milesArray objectAtIndex:0]doubleValue]];
            [Vehicles currentVehicle][@"Odometer"] = [NSString stringWithFormat:@"%0.1f", [[self.MilesInput text] doubleValue] + [[self.milesArray objectAtIndex:0]doubleValue]];
        }
        
        fillup[@"MPG"] = [NSString stringWithFormat:@"%0.1f", self.MPG];
        [Vehicles currentVehicle][@"MPG"] = [NSString stringWithFormat:@"%0.1f", self.MPG];
        fillup[@"Price"] = [NSString stringWithFormat:@"%0.2f", self.Price];
        [Vehicles currentVehicle][@"Price"] = [NSString stringWithFormat:@"%0.2f", self.Price];
        
        [fillup saveInBackground];
        [[Vehicles currentVehicle] saveInBackground];
    }
    
//    UIAlertView *inputSentMessage = [[UIAlertView alloc]initWithTitle:@"Thank You" message:@"Your information has been saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    
//    [inputSentMessage show];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)CancelFillupInput:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return 4;
}




//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fillupInput" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.55];
//    
//    return cell;
//}


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
