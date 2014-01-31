//
//  ViewController.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "MapViewController.h"
#import "VenuesSerializer.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <HttpRequestDelegate, VenuesSerializerDelegate, CLLocationManagerDelegate>

@end

@implementation ViewController
{
    NSString* _oauth_token;
    CLLocationManager* _locationManager;
    CLLocationCoordinate2D _locationCoordinates;
    VenuesSerializer* _venuesSerializer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self checkIfLogged];
    [self initLocationManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initLocationManager
{
    if (![CLLocationManager locationServicesEnabled]){
        [Utilities displayError:@"location services are disabled"];
          return;
      }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        [Utilities displayError:@"location services are blocked by the user"];
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        NSLog(@"about to show a dialog requesting permission");
    }
        
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 10.0f;//kCLDistanceFilterNone; //
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];

    
}

-(void)checkIfLogged
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if( [defaults valueForKey:@"access_token"])
    {
        _oauth_token = [defaults valueForKey:@"access_token"];
        return ;
    }
    
    [self performSegueWithIdentifier:@"loginSegue"sender:self];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* currentLocation = locations[0];
    _locationCoordinates = [currentLocation coordinate];
    [self getTrendingVenues: _locationCoordinates.latitude longitude:_locationCoordinates.longitude];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"mapViewSegue"])
    {
        MapViewController* mapController = (MapViewController*)segue.destinationViewController;
        mapController.locationCoordinates = _locationCoordinates;
    }
}

-(void)getTrendingVenues:(float)latitude longitude:(float)longitude
{
    NSString* url = [[NSString alloc] initWithFormat: @TRENDING_URL, latitude,longitude, _oauth_token];
    [RequestManager createRequest:url httpMethod:@"GET" delegate:self];
}

-(void)recieveSerializedVenues:(NSArray *)venues Categories:(NSDictionary *)categories
{
    
}


-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"response"])
    {
        _venuesSerializer = [[VenuesSerializer alloc]
                             initWithData:[[responseData objectForKey:@"response"]
                                           objectForKey:@"venues"] ];
        
        [_venuesSerializer serializeVenuesAsync:self];
        
//        NSArray* str = [[responseData objectForKey:@"response"] objectForKey:@"venues"];
//        NSDictionary* d = str[0];
//        NSString* name = [d objectForKey:@"name"];
//        NSDictionary* loc = [d objectForKey:@"location"];
//        NSString* address = [loc objectForKey:@"address"];
    }
}

-(void)handleError:(NSError *)error
{
    
}
@end
