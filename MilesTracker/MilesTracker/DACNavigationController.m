//
//  DACNavigationController.m
//  MilesTracker
//
//  Created by Mac User on 7/10/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACNavigationController.h"
#import <REFrostedViewController/REFrostedViewController.h>

@interface DACNavigationController ()

@end

@implementation DACNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:17/255.0f green:69/255.0f blue:114/255.0f alpha:1.0];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}
@end
