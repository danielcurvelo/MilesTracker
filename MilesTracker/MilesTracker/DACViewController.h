//
//  DACViewController.h
//  MilesTracker
//
//  Created by Mac User on 6/26/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

@interface DACViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

-(void)retrieveParse:(NSArray *)objects;


@end
