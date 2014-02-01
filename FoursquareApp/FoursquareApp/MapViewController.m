//
//  MapViewController.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "MapViewController.h"
#import "Venue.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@end

@implementation MapViewController

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
	// Do any additional setup after loading the view.
    self.mapView.delegate  = self;
    [self centerMapOnUserLocation];
    [self addVenuesToMap];
    
   
    
}

-(void)centerMapOnUserLocation
{
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 0);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(_locationCoordinates, span);
    [_mapView setRegion:viewRegion animated:YES];
}

-(void) addVenuesToMap
{
    for (id categoryKey in self.venues) {
        NSArray* arr = [self.venues objectForKey:categoryKey];
        
        [self.mapView addAnnotations:arr];
        
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
