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
#import "Venue.h"
#import "VenueDetailsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate, VenuesSerializerDelegate, CLLocationManagerDelegate>

@end

@implementation ViewController
{
    NSString* _oauth_token;
    CLLocationManager* _locationManager;
    CLLocationCoordinate2D _locationCoordinates;
    VenuesSerializer* _venuesSerializer;
    
    NSArray* _categories;
    NSDictionary* _venues;
    Venue* _selectedVenue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self checkIfLogged];
//    [self initLocationManager];
    _venuesSerializer = [VenuesSerializer alloc];
    self.venueTable.delegate = self;
    self.venueTable.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self checkIfLogged];
    [self initLocationManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"mapViewSegue"])
    {
        MapViewController* mapController = (MapViewController*)segue.destinationViewController;
        mapController.locationCoordinates = _locationCoordinates;
        mapController.venues = _venues;
    }
    else if([segue.identifier isEqualToString:@"venueDetailsSegue"])
    {
        VenueDetailsViewController* detailsController = (VenueDetailsViewController*)segue.destinationViewController;
        detailsController.venue = _selectedVenue;
        detailsController.userLocation = _locationCoordinates;
        
    }
}

-(void)recieveSerializedVenues:(NSDictionary *)venues Categories:(NSArray *)categories
{
    _venues = venues;
    _categories = categories;
    
    [self.venueTable reloadData];
    
}

#pragma mark LocationRelated

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
    _locationManager.distanceFilter = 30.0f;//kCLDistanceFilterNone; //
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    
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

#pragma mark TableDelegateMethods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_categories count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _categories[section];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* categoryKey = [_categories objectAtIndex:section];
    if([_venues objectForKey:categoryKey])
    {
        NSArray* arr = [_venues valueForKey: categoryKey];
        return [arr count];
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell.
    NSString* key = [_categories objectAtIndex:indexPath.section];
    NSArray* rowsInSection = [_venues valueForKey:key];
    Venue* venueEntry =[rowsInSection objectAtIndex:indexPath.item];
    
    UILabel* venueName = (UILabel*)[cell viewWithTag:1];
    UILabel* venueDistance = (UILabel*)[cell viewWithTag:2];
    UILabel* venueAddress = (UILabel*)[cell viewWithTag:3];
    
    venueName.text = venueEntry.Name;
    float distance = venueEntry.Distance;
    venueDistance.text = [[NSString alloc] initWithFormat:@"Dist: %.0f m", distance];
    venueAddress.text = venueEntry.Address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_categories count] == 0 || [_venues count] == 0)
    {
        return;
    }
    
    NSString* categoryKey = [_categories objectAtIndex:indexPath.section];
    
    NSArray* venues = [_venues objectForKey:categoryKey];
    
    _selectedVenue = venues[indexPath.item];
    [self performSegueWithIdentifier:@"venueDetailsSegue" sender:self];
}

#pragma mark NetworkCalls

-(void)getTrendingVenues:(float)latitude longitude:(float)longitude
{
    NSString* url = [[NSString alloc] initWithFormat: @TRENDING_URL, latitude,longitude, _oauth_token];
    [RequestManager createRequest:url httpMethod:@"GET" delegate:self];
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"response"])
    {
        _venuesSerializer = [_venuesSerializer
                             loadData:[[responseData objectForKey:@"response"]
                                           objectForKey:@"venues"] ];
        
        [_venuesSerializer serializeVenuesAsync:self];
        
    }
}

-(void)handleError:(NSError *)error
{
    
}
@end
