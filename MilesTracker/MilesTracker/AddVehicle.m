//
//  AddVehicle.m
//  
//
//  Created by Mac User on 7/12/14.
//
//

#import "AddVehicle.h"
#import "DACVehicleController.h"
#import "Vehicles.h"
#import "DACVehicleController.h"
#import "DACNavigationController.h"
#import "DACTableViewDataSource.h"
#import <Parse/Parse.h>

@interface AddVehicle ()
@property (strong, nonatomic) IBOutlet UITextField *nameVehicleText;
@property (strong, nonatomic) IBOutlet UITextField *vinText;
@property (strong, nonatomic) IBOutlet UIButton *vinBtn;
@property (strong, nonatomic) IBOutlet UILabel *labelMake;
@property (strong, nonatomic) IBOutlet UILabel *labelModel;
@property (strong, nonatomic) IBOutlet UILabel *labelYear;
@property (strong, nonatomic) IBOutlet UILabel *labelCity;
@property (strong, nonatomic) IBOutlet UILabel *labelhighway;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *createVehicleBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelVehicleBigBtn;
@end

@implementation AddVehicle

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =[UIColor colorWithRed:17/255.0f green:69/255.0f blue:114/255.0f alpha:1.0];
//    self.labelCity.layer.cornerRadius = 10.0;
//    self.labelhighway.layer.cornerRadius = 10.0;

}
- (IBAction)SearchVehicle:(UITextField *)vinText {
    [[DACVehicleController sharedInstance] searchForVehicles:self.vinText.text completion:^(BOOL success, Vehicles *vehicle) {
        if (success){
            self.labelMake.text = vehicle.vehicleMake;
            self.labelModel.text = vehicle.vehicleModel;
            self.labelYear.text = vehicle.vehicleYear;
            self.labelCity.text = vehicle.cityMPG;
            self.labelhighway.text = vehicle.highwayMPG;
        }else{
            UIAlertView *vinFailed = [[UIAlertView alloc]initWithTitle:@"Wrong Vin Number" message:@"Vin number doesn't match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [vinFailed show];
        }
        [self.vinText resignFirstResponder];
    }];
}
- (IBAction)cancelVehicleBigButton:(UIButton *)cancelVehicleBigBtn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)sendVehicleToParse:(UIButton *)createVehicleBtn {
#pragma mark - Send to Parse

    [[DACVehicleController sharedInstance] searchForVehicles:self.vinText.text completion:^(BOOL success, Vehicles *vehicle) {
        if (success){
            PFObject *vehicleObject = [PFObject objectWithClassName:@"Vehicles"];
            vehicleObject[@"Name"] = self.nameVehicleText.text;
            vehicleObject[@"Make"] = vehicle.vehicleMake;
            vehicleObject[@"Model"] = vehicle.vehicleModel;
            vehicleObject[@"Year"] = vehicle.vehicleYear;
            vehicleObject[@"CityMPG"] = vehicle.cityMPG;
            vehicleObject[@"HighwayMPG"] = vehicle.highwayMPG;
            [vehicleObject saveInBackground];
        }
        }];
    [self.navigationController popToRootViewControllerAnimated:YES];
 
}

- (IBAction)cancelVehicle:(UIButton *)cancelBtn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
