//
//  RequestManager.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "RequestManager.h"

//@interface RequestManager () <NSURLConnectionDelegate>
//
//@end

@implementation RequestManager

+(void) createRequest:(NSString *)path httpMethod:(NSString *)method sentData:(NSDictionary *)dictionary delegate:(id<HttpRequestDelegate>)vcDelegate
{
    
}

+(void) createRequest:(NSString *)path httpMethod:(NSString *)method delegate:(id<HttpRequestDelegate>)vcDelegate
{
    NSURL* url = [NSURL URLWithString:path];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:	url];
    
    [req setHTTPMethod:method];
    [req setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection
     sendAsynchronousRequest:req
     queue:[[NSOperationQueue alloc]init]
     completionHandler:^(NSURLResponse* resp, NSData* responseData, NSError* error){
         
         NSDictionary* respDictionary = [NSJSONSerialization JSONObjectWithData: responseData
             options:NSJSONReadingAllowFragments
              error:nil];
//         NSDictionary* respDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
             if(error == nil)
             {
                 [vcDelegate handleSuccess:respDictionary];
             }
             else
             {
                 [vcDelegate handleError:error];
             }
         });
     }];
    
}


@end
