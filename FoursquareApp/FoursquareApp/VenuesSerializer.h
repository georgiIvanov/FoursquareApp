//
//  VenuesSerializer.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VenuesSerializerDelegate <NSObject>

-(void) recieveSerializedVenues:(NSArray*) venues Categories:(NSDictionary*)categories;

@end

@interface VenuesSerializer : NSObject

-(VenuesSerializer*)initWithData:(NSDictionary*)venues;
-(void)serializeVenuesAsync:(id<VenuesSerializerDelegate>) delegate;
@end
