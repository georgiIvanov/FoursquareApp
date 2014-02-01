//
//  MapViewController.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "MapViewController.h"
#import "Venue.h"
#import "RequestManager.h"
#import "Constants.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <HttpRequestDelegate, MKMapViewDelegate>

@end

@implementation MapViewController
{
    NSMutableArray* _path;
    MKPolyline* _navigationPolyline;
}

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
    if(self.viewingOneVenue)
    {
        [self getRouteToVenue];
    }
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
    self.locationCoordinates = userLocation.location.coordinate;
    if(self.viewingOneVenue)
    {
        [self getRouteToVenue];
        if(_navigationPolyline != nil)
        {
            [self.mapView removeOverlays:self.mapView.overlays];
            _navigationPolyline = nil;
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    lineView.strokeColor = [UIColor redColor];
    lineView.lineWidth = 3;
    
    return lineView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getRouteToVenue
{
    Venue* venue;
    
    for (id categoryKey in self.venues) {
        NSArray* arr = [self.venues objectForKey:categoryKey];
        venue = [arr objectAtIndex:0];
    }
    
    NSString* reqUrl = [[NSString alloc] initWithFormat:@DIRECTION_URL, self.locationCoordinates.latitude, self.locationCoordinates.longitude, venue.Latitude, venue.Longitude, @"driving"];
    
    [RequestManager createRequest:reqUrl httpMethod:@"GET" delegate:self];
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([[responseData objectForKey:@"status"] isEqualToString:@"OK"])
    {
        NSArray *routes = [responseData objectForKey:@"routes"];
        NSDictionary *route = [routes lastObject];
        if (route) {
            NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
            _path = [self decodePolyLine:overviewPolyline];
            
            NSInteger numberOfSteps = _path.count;
            
            CLLocationCoordinate2D coordinates[numberOfSteps];
            for (NSInteger index = 0; index < numberOfSteps; index++) {
                CLLocation *location = [_path objectAtIndex:index];
                CLLocationCoordinate2D coordinate = location.coordinate;
                
                coordinates[index] = coordinate;
            }
            
            _navigationPolyline = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
            
            
            [self.mapView addOverlay:_navigationPolyline];
            
            [self.mapView setNeedsDisplay];
        }
    }
    
}

-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
    
    return array;
}


@end
