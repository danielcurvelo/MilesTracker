//
//  SignUpViewController.h
//  MilesTracker
//
//  Created by Mac User on 7/30/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *usernameInput;
@property (strong, nonatomic) IBOutlet UITextField *emailInput;
@property (strong, nonatomic) IBOutlet UITextField *passwordInput;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@end
