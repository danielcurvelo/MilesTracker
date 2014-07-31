//
//  DACCarInfoViewController.m
//  
//
//  Created by Mac User on 7/10/14.
//
//

#import "DACCarInfoViewController.h"
#import "DACChooseVehicle.h"
#import "DACVehicleController.h"
#import "Vehicles.h"
#import <Parse/Parse.h>
#import <iOSPlot/PCLineChartView.h>
#import <iOSPlot/PCPieChart.h>

@interface DACCarInfoViewController ()
@property (strong, nonatomic) IBOutlet UIButton *addVehicleBtn;
@property (strong, nonatomic) IBOutlet UIButton *ChooseVehicleBtn;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapgest;
@property (nonatomic, strong) PFObject *vehicle;
@property (nonatomic, strong) NSArray *fillupArray;
@property (strong, nonatomic) IBOutlet UIView *chartView;
@property (readwrite,nonatomic) double MPG;
@property (readwrite,nonatomic) double total;
@property (readwrite,nonatomic) double mileage;
@property (strong, nonatomic) IBOutlet UILabel *mileageLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *mpgLabel;
@property (strong, nonatomic) IBOutlet UIView *mileageBackground;
@property (strong, nonatomic) IBOutlet UIView *totalBackground;
@property (strong, nonatomic) IBOutlet UIView *mpgBackground;
@property (strong, nonatomic) IBOutlet UIView *infoBackground;
@property (strong, nonatomic) IBOutlet UILabel *overallLabel;
@property (strong, nonatomic) IBOutlet UILabel *milesInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalSpentLabel;
@property (strong, nonatomic) IBOutlet UILabel *avgMPGInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *makeLabel;
@property (strong, nonatomic) IBOutlet UILabel *modelLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (nonatomic,strong) NSArray *fillupInfo;
@property (strong, nonatomic) IBOutlet UIView *cityMPGBackground;
@property (strong, nonatomic) IBOutlet UIView *highwayMPGBackground;
@property (strong, nonatomic) IBOutlet UILabel *cityMPGLabelBackground;
@property (strong, nonatomic) IBOutlet UILabel *highwayMPGLabelBackground;
@property (strong, nonatomic) IBOutlet UILabel *cityMPGLabel;
@property (strong, nonatomic) IBOutlet UILabel *highwayMPGLabel;
@property (strong, nonatomic) IBOutlet UIView *carInfoBackground;
@end

@implementation DACCarInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

	}
	return self;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"VehicleChooser"]) {
        UINavigationController *navController = [segue destinationViewController];
        DACChooseVehicle *TripController = (DACChooseVehicle *)([navController viewControllers][0]);
        [TripController setOnVehicleSelected:^ {
            [self dismissViewControllerAnimated:YES completion:nil];
            self.ChooseVehicleBtn.titleLabel.text = [Vehicles currentVehicle][@"Name"]
            ;
            PFQuery *query = [PFQuery queryWithClassName:@"fillup"];
            [query whereKey:@"Vehicles" equalTo:[Vehicles currentVehicle]];
            self.fillupArray = [query findObjects];
            [self getCalculations];
            self.mileageLabel.text = [NSString stringWithFormat:@"%0.1f",self.mileage];
            self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f",self.total];
            self.mpgLabel.text = [NSString stringWithFormat:@"%0.1f",self.MPG];
            
            self.makeLabel.text = [Vehicles currentVehicle][@"Make"];
            self.modelLabel.text = [Vehicles currentVehicle][@"Model"];
            self.yearLabel.text = [Vehicles currentVehicle][@"Year"];
            self.cityMPGLabel.text = [Vehicles currentVehicle][@"CityMPG"];
            self.highwayMPGLabel.text = [Vehicles currentVehicle][@"HighwayMPG"];
        }];
    }
}
//- (IBAction)tapped:(id)sender {
//    
//    
//    if([Vehicles currentVehicle]) {
//        
//        NSLog(@"object id is: %@",[Vehicles currentVehicle].objectId);
//        PFQuery *query = [PFQuery queryWithClassName:@"fillup"];
//        [query whereKey:@"Vehicles"  equalTo:[Vehicles currentVehicle]];
//            NSLog(@"info: %@",query);
//        
//            [self.chartView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
//            [self setTitle:@"Line Chart"];
//            
//            _lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(10,10,[self.chartView bounds].size.width-20,[self.chartView bounds].size.height-20)];
//            [_lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//            _lineChartView.minValue = 0;
//            _lineChartView.maxValue = 40;
//            [self.chartView addSubview:_lineChartView];
//            
//            
//            
//            //    NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"sample_linechart_data.json"];
//            //    NSString *jsonString = [NSString stringWithContentsOfFile:sampleFile encoding:NSUTF8StringEncoding error:nil];
//            
//            NSDictionary *sampleInfo = [Vehicles currentVehicle][@"MPG"];
//            NSLog(@"info: %@",sampleInfo);
//            NSMutableArray *components = [NSMutableArray array];
//            for (int i=0; i<[[sampleInfo objectForKey:@"data"] count]; i++)
//            {
//                NSDictionary *point = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
//                PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
//                [component setTitle:[point objectForKey:@"title"]];
//                [component setPoints:[point objectForKey:@"data"]];
//                [component setShouldLabelValues:NO];
//                [component setColour:PCColorGreen];
//
//                
//                [components addObject:component];
//            }
//            [_lineChartView setComponents:components];
//            [_lineChartView setXLabels:[sampleInfo objectForKey:@"x_labels"]];
//            // Do something with the returned PFObject in the gameScore variable.
//    }else{
//        
//    }
//    
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	[self.lineChartView setNeedsDisplay];
//    return YES;
//}

-(void)getCalculations
{
    
    NSDecimalNumber *total = [self.fillupArray valueForKeyPath:@"@sum.Total.doubleValue"];
    self.total = total.doubleValue;
    
    NSDecimalNumber *mileage = [self.fillupArray valueForKeyPath:@"@sum.Miles.doubleValue"];
    self.mileage = mileage.doubleValue;
    
    NSDecimalNumber *mpg = [self.fillupArray valueForKeyPath:@"@sum.MPG.doubleValue"];
    self.MPG = mpg.doubleValue;
    self.MPG = self.MPG / self.fillupArray.count;
    
    
    ////    self.MPG = [self.objects[@"MPG"] doubleValue];
    //    self.total = [self.trip[@"Total"] doubleValue];
    //    self.mileage = [self.trip[@"Miles"] doubleValue];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorWithRed:17/255.0f green:69/255.0f blue:114/255.0f alpha:1.0];
    self.carInfoBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    self.carInfoBackground.layer.borderWidth = 1;
    self.carInfoBackground.layer.cornerRadius = 10;
    self.carInfoBackground.layer.masksToBounds = YES;
    
#pragma mark - Pie Chart
    
//    int height = [self.view bounds].size.width/3*2.; // 220;
//    int width = [self.view bounds].size.width; //320;
//    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height + 180 )/2,width,height)];
//    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
//    [pieChart setDiameter:width/2];
//    [pieChart setSameColorLabel:YES];
//    
//    [self.view addSubview:pieChart];
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
//    {
//        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
//        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
//    }
//    
//    NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"sample_piechart_data.plist"];
//    NSDictionary *sampleInfo = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
//    NSMutableArray *components = [NSMutableArray array];
//    for (int i=0; i<[[sampleInfo objectForKey:@"data"] count]; i++)
//    {
//        NSDictionary *item = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
//        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
//        [components addObject:component];
//        
//        if (i==0)
//        {
//            [component setColour:PCColorYellow];
//        }
//        else if (i==1)
//        {
//            [component setColour:PCColorGreen];
//        }
//        else if (i==2)
//        {
//            [component setColour:PCColorOrange];
//        }
//        else if (i==3)
//        {
//            [component setColour:PCColorRed];
//        }
//        else if (i==4)
//        {
//            [component setColour:PCColorBlue];
//        }
//    }
//    [pieChart setComponents:components];
    
#pragma mark -LineChart
    self.totalBackground.layer.borderWidth = 2;
    self.mileageBackground.layer.borderWidth = 2;
    self.mpgBackground.layer.borderWidth = 2;
    self.infoBackground.layer.borderWidth = 2;
    self.totalBackground.layer.borderColor =
    self.infoBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    self.mileageBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    self.mpgBackground.layer.borderColor = [UIColor orangeColor].CGColor;
    self.totalBackground.layer.cornerRadius = 37;
    self.mileageBackground.layer.cornerRadius = 37;
    self.mpgBackground.layer.cornerRadius = 37;
    self.infoBackground.layer.cornerRadius = 8;

    self.overallLabel.layer.cornerRadius = 5;
    self.milesInfoLabel.layer.cornerRadius = 5;
    self.totalSpentLabel.layer.cornerRadius = 5;
    self.avgMPGInfoLabel.layer.cornerRadius =5;
    
    self.cityMPGBackground.layer.cornerRadius =37;
    self.highwayMPGBackground.layer.cornerRadius = 37;
    self.cityMPGLabelBackground.layer.cornerRadius = 8;
    self.highwayMPGLabelBackground.layer.cornerRadius =8;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadInputViews];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
