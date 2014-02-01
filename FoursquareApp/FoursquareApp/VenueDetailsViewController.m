//
//  VenueDetailsViewController.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 2/1/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "VenueDetailsViewController.h"
#import "MapViewController.h"

@interface VenueDetailsViewController ()

@end

@implementation VenueDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"mapViewSegue"])
    {
        MapViewController* mapController = (MapViewController*)segue.destinationViewController;
        mapController.locationCoordinates = self.userLocation;
        
        mapController.venues = [self passVenueToMapController];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *map = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openMapWithVenue)];
    UIBarButtonItem *checkIn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeCheckIn)];
    
    NSArray *actionButtonItems = @[checkIn, map];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    [self initializeLabels];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeLabels
{
    self.venueName.text = self.venue.Name;
    self.category.text = self.venue.Category;
    self.userCount.text = [[NSString alloc] initWithFormat:@"%d", self.venue.HereNow];
    self.distance.text = [[NSString alloc] initWithFormat:@"%.0f", self.venue.Distance];
    if(self.venue.Url == nil)
    {
        self.url.text = @"Unknown";
    }
    else
    {
        self.url.text = self.venue.Url;
    }
    self.address.text = self.venue.Address;
}

-(void) writeCheckIn
{
    
}

-(void) openMapWithVenue
{
    [self performSegueWithIdentifier:@"mapViewSegue" sender:self];
}

-(NSDictionary*)passVenueToMapController
{
    
    NSArray* venueArr = [[NSArray alloc]initWithObjects:self.venue, nil];
    NSMutableDictionary* venues = [[NSMutableDictionary alloc]init];
    [venues setValue:venueArr forKey:self.venue.Category];
    
    return venues;
}

@end
