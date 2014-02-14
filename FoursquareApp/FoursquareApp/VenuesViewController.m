//
//  ViewController.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "VenuesViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "MapViewController.h"
#import "VenuesSerializer.h"
#import "Venue.h"
#import "VenueDetailsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface VenuesViewController () <UITableViewDataSource, UITableViewDelegate, HttpRequestDelegate, VenuesSerializerDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) UIImageView* backgroundImageView;
@end

@implementation VenuesViewController
{
    NSString* _oauth_token;
    CLLocationManager* _locationManager;
    CLLocationCoordinate2D _locationCoordinates;
    VenuesSerializer* _venuesSerializer;
    
    NSArray* _categories;
    NSDictionary* _venues;
    Venue* _selectedVenue;
    
    // prevents checking location several times
    // on startup
    BOOL _justCheckedLocation;
    
   
}

- (void)viewDidLoad
{
   

    [super viewDidLoad];
    _venuesSerializer = [VenuesSerializer alloc];
    self.venueTable.delegate = self;
    self.venueTable.dataSource = self;
    self.view.backgroundColor = [UIColor clearColor];
    
    _justCheckedLocation = NO;

    UIImage *background = [UIImage imageNamed:@"bg.jpg"];
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //    [self.view addSubview:self.backgroundImageView];
    [self.view sendSubviewToBack:self.backgroundImageView];
    self.venueTable.backgroundColor = [UIColor clearColor];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.activityIndicator startAnimating];
    [self checkIfLogged];
    [self initLocationManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

-(IBAction)returnToMainController:(UIStoryboardSegue*)segue
{
    
}

-(void)recieveSerializedVenues:(NSDictionary *)venues Categories:(NSArray *)categories
{
    _venues = venues;
    _categories = categories;
    [self.activityIndicator stopAnimating];
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
    if(_oauth_token != nil)
    {
        [Utilities displayError:@"Cannot find your position. Make sure you allowed to get your location and you are connected to the internet."];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(_justCheckedLocation)
    {
        return;
    }
    CLLocation* currentLocation = locations[0];
    _locationCoordinates = [currentLocation coordinate];
    [self getTrendingVenues: _locationCoordinates.latitude longitude:_locationCoordinates.longitude];
    _justCheckedLocation = YES;
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect r = CGRectMake(0, 0, tableView.bounds.size.width, 30);
    UIView* view = [[UIView alloc] initWithFrame:r];
    view.backgroundColor = SECTION_COLOR;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] ;
    label.text = [_categories objectAtIndex:section];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    return view;	
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
    
    _justCheckedLocation = NO;
}

-(void)handleError:(NSError *)error
{
    if(_oauth_token && _justCheckedLocation)
    {
        [self performSegueWithIdentifier:@"loginSegue"sender:self];
    }
    
    _justCheckedLocation = NO;
}

@end
