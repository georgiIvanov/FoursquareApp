//
//  VenueDetailsViewController.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 2/1/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "VenueDetailsViewController.h"
#import "MapViewController.h"
#import "RequestManager.h"
#import "Utilities.h"
#import "Constants.h"

@interface VenueDetailsViewController () <HttpRequestDelegate, UIAlertViewDelegate>

@end

@implementation VenueDetailsViewController
{
    
}
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
        mapController.viewingOneVenue = YES;
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavBarButtons];
    [self initializeLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavBarButtons
{
    UIBarButtonItem *map = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openMapWithVenue)];
    UIBarButtonItem *checkIn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeCheckIn)];
    
    
    
    if(self.venue.Distance < CHECKING_DISTANCE)
    {
        checkIn.enabled = YES;
    }
    else
    {
        checkIn.enabled = NO;
    }
    
    NSArray *actionButtonItems = @[checkIn, map];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
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
    [Utilities writeCheckIn:self];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString* text = [alertView textFieldAtIndex:0].text;
        if(text.length > 140)
        {
            alertView.message = @"Message too long :<";
            [alertView show];
        }
        else
        {
            NSMutableDictionary* sentData = [[NSMutableDictionary alloc]init];
            if(![text  isEqual: @""])
            {
                [sentData setObject:text forKey:@"shout"];
            }
            [sentData setObject: [[NSString alloc] initWithFormat:@"%f,%f",
                                  self.userLocation.latitude, self.userLocation.longitude]
                         forKey:@"ll"];
            NSString* requestUrl = [[NSString alloc] initWithFormat:@CHECKIN_URL,
                                    [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],
                                    self.venue.Id];
            
            [RequestManager createRequest:requestUrl
                               httpMethod:@"POST"
                                 sentData:sentData
                                 delegate:self];
        }
    }
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

-(void)handleSuccess:(NSDictionary *)responseData
{
    if([responseData objectForKey:@"response"])
    {
        NSDictionary* response = [responseData objectForKey:@"response"];
        NSDictionary* checkin = [response objectForKey:@"checkin"];
        id score = [checkin objectForKey:@"score"];
        
        id venue = [checkin objectForKey:@"venue"];
        id reasons = [venue objectForKey:@"reasons"];
        
        NSArray* scores = [score objectForKey:@"scores"];
        int totalScore = [[score objectForKey:@"total"] intValue];
        NSArray* reasonItems = [reasons objectForKey:@"items"];

        NSMutableString* result = [[NSMutableString alloc] init];
        
        for (id item in reasonItems) {
            [result appendFormat:@"%@\r", [item objectForKey:@"summary"]];
        }
        
        [result appendString:@"\r\r"];
        
        for (id scoreItem in scores) {
            [result appendFormat:@"%@ - %d\r",
             [scoreItem objectForKey:@"message"], [[scoreItem objectForKey:@"points"] intValue] ];
        }
        
        [result appendString:@"\r\r"];
        [result appendFormat:@"Total score: %d", totalScore];
        
        self.checkInTextView.text = result;
    }
}

@end
