//
//  MapViewController.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property (nonatomic) CLLocationCoordinate2D locationCoordinates;
@property (nonatomic) NSDictionary* venues;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
