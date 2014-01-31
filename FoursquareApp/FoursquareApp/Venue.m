//
//  Venue.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "Venue.h"

@implementation Venue

//@synthesize coordinate;
//@synthesize title;
//@synthesize subtitle;

-(Venue*) initWithName:(NSString*)name
               Address:(NSString*)address
              Category:(NSString*)category
              Latitude:(float)lat
             Longitude:(float)lon
              Distance:(float)distance
               HereNow:(int)hereNow
                    Id:(NSString*) foursquareId
                   Url:(NSString *)url;
{
    self.Name = name;
    self.Address = address;
    self.Category = category;
    self.Latitude = lat;
    self.Longitude = lon;
    self.Distance = distance;
    self.HereNow = hereNow;
    self.Id = foursquareId;
    self.Url = url;
    return self;
}

- (CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D coords;
    coords.latitude = self.Latitude;
    coords.longitude =  self.Longitude;
    
    return coords;
}

- (NSString *) title {
    return self.Name;
}

- (NSString *) subtitle {
    NSString* sub = [[NSString alloc] initWithFormat:@"%.0f m, Here: %d",self.Distance, self.HereNow];
    return sub;
}

@end
