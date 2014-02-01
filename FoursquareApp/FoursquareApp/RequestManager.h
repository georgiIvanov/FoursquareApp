//
//  RequestManager.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpRequestDelegate <NSObject>

-(void)handleSuccess:(NSDictionary*)responseData;

@optional
-(void)handleError:(NSError*)error;

@end

@interface RequestManager : NSObject
+(void) createRequest:(NSString*)path
           httpMethod:(NSString*)method
             sentData:(NSDictionary*)dictionary
             delegate:(id<HttpRequestDelegate>)vcDelegate;

+(void) createRequest:(NSString*)path
               httpMethod:(NSString*)method
                 delegate:(id<HttpRequestDelegate>)vcDelegate;

@end
