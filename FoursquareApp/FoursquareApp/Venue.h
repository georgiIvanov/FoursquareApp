//
//  Venue.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Venue : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;


-(Venue*) initWithName:(NSString*)name
               Address:(NSString*)address
              Category:(NSString*)category
              Latitude:(float)lat
             Longitude:(float)lon
              Distance:(float)distance
               HereNow:(int)hereNow
                    Id:(NSString*) foursquareId
                   Url:(NSString*) url;



@property(nonatomic, retain) NSString* Name;
@property(nonatomic, retain) NSString* Address;
@property(nonatomic) float Latitude;
@property(nonatomic) float Longitude;
@property(nonatomic) float Distance;
@property(nonatomic) int HereNow;
@property(nonatomic, retain) NSString* Category;
@property(nonatomic, retain) NSString* Id;
@property(nonatomic, retain) NSString* Url;



@end
