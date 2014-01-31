//
//  Utilities.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(void)displayError:(NSString*)errorMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message: errorMsg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}


@end
