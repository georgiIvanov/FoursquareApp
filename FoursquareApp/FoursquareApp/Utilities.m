//
//  Utilities.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "Utilities.h"
#import <math.h>

@implementation Utilities

+(void)displayError:(NSString*)errorMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"                                                  message: errorMsg                                                   delegate:nil                                          cancelButtonTitle:@"OK"                                          otherButtonTitles:nil];
    
    [alert show];
}

+(void)writeCheckIn:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Write your check in message"                                                          message:@"you have 140 symbols, use them wisely" delegate:delegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"Check In", nil];
    
    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [myAlertView show];
}

@end
