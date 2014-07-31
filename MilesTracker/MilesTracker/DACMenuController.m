//
//  DACMenuController.m
//  MilesTracker
//
//  Created by Mac User on 7/10/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "DACMenuController.h"

@interface DACMenuController ()

@end

@implementation DACMenuController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

@end
