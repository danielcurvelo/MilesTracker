//
//  MyAnnotation.h
//  MilesTracker
//
//  Created by Mac User on 7/26/14.
//  Copyright (c) 2014 DanceologyStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString*)newTitle location:(CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;

@end

