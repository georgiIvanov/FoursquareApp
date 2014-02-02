//
//  Constants.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TRENDING_URL "https://api.foursquare.com/v2/venues/trending?ll=%f,%f&oauth_token=%@&v=20140130"

#define AUTH_URL "https://foursquare.com/oauth2/authenticate?client_id=3PQ30YSKEP5RAOKDR452A14QVZ4NL2DTK1JN1LGCR4JAQ2YF&response_type=token&redirect_uri=http://georgi-ivanov.com/"

#define DIRECTION_URL "https://maps.googleapis.com/maps/api/directions/json?sensor=true&destination=%3.6f,%3.6f&origin=%3.6f,%3.6f&mode=%@"

#define CHECKIN_URL "https://api.foursquare.com/v2/checkins/add?oauth_token=%@&venueId=%@&v=20140130"

#define CHECKING_DISTANCE 350

#define SECTION_COLOR [UIColor colorWithRed:131/255.0f green:202/255.0f blue:100/255.0f alpha:1.0f];

// lat 42.6932869739926
// lon 23.3286389708519