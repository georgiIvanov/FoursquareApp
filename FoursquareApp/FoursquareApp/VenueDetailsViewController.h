//
//  VenueDetailsViewController.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 2/1/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface VenueDetailsViewController : UIViewController

@property(nonatomic, weak) Venue* venue;
@property(nonatomic) CLLocationCoordinate2D userLocation;

@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *userCount;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *url;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITextView *checkInTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
