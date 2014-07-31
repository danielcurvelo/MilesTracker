//
//  MyAnnotation.m
//  MilesTracker
//
//  Created by Mac User on 7/26/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import "MyAnnotation.h"
#import <AddressBook/AddressBook.h>

@implementation MyAnnotation

- (id)initWithTitle:(NSString*)newTitle location:(CLLocationCoordinate2D)location{
    self = [super init];
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"arrow.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

@end
