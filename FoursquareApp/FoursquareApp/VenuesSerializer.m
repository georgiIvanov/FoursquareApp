//
//  VenuesSerializer.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "VenuesSerializer.h"
#import "Venue.h"

@implementation VenuesSerializer
{
    NSDictionary* _venuesToSerialize;
    NSArray* _serializedVenues;
    NSMutableArray* _categories;
}

-(VenuesSerializer*) loadData:(NSDictionary *)venues
{
    _venuesToSerialize = venues;
    return self;
}

-(void)serializeVenuesAsync:(id<VenuesSerializerDelegate>)delegate
{
//    if([_venuesToSerialize count] == 0)
//    {
//        [NSException raise:@"No venues to serialize" format:@"Count cannot be %d", [_venuesToSerialize count]];
//    }
    
    @synchronized(self)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), 	^{
           
            
            NSDictionary* result = [[NSDictionary alloc] initWithDictionary:
                               [self serializeDictionaryToArrayVenues]];
            NSArray* categories = [[NSArray alloc] initWithArray:_categories];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [delegate recieveSerializedVenues:result Categories:categories];
            });
        });
    }
}

-(NSMutableDictionary*) serializeDictionaryToArrayVenues
{
    NSUInteger count = [_venuesToSerialize count];
    NSMutableDictionary* result = [[NSMutableDictionary alloc] initWithCapacity: count];
    _categories = [[NSMutableArray alloc] init];
    
    NSString* name;
    NSString* address;
    NSString* category;
    NSString* fsId;
    NSString* url;
    float lat, lon, distance;
    NSDictionary* innerObjects;
    int hereNow;
    for (id venue in _venuesToSerialize) {
        name = [venue objectForKey:@"name"];
        fsId = [venue objectForKey:@"id"];
        url = [venue objectForKey:@"url"];
        
        innerObjects = [venue objectForKey:@"location"];
        address = [innerObjects objectForKey:@"address"];
        lat = [[innerObjects objectForKey:@"lat"] floatValue];
        lon = [[innerObjects objectForKey:@"lng"] floatValue];
        distance = [[innerObjects objectForKey:@"distance"] floatValue];
        
        category = [[venue objectForKey:@"categories"][0] objectForKey:@"pluralName"];
        hereNow = [[[venue objectForKey:@"hereNow"] objectForKey:@"count"] intValue];
        
        Venue* venueEntry = [[Venue alloc]
                             initWithName:name
                             Address:address
                             Category:category
                             Latitude:lat
                             Longitude:lon
                             Distance:distance
                             HereNow:hereNow
                             Id:fsId
                             Url:url];
        
        if([result objectForKey:category])
        {
            NSMutableArray* venuesInCategory = [result objectForKey:category];
            [venuesInCategory addObject:venueEntry];
            
        }
        else
        {
            NSMutableArray* venuesInCategory = [[NSMutableArray alloc] init];
            [venuesInCategory addObject:venueEntry];
            [result setObject:venuesInCategory forKey:category];
            [_categories addObject:category];
        }
    }
    
    
    
    return result;
}

@end
