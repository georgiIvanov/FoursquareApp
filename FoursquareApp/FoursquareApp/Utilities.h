//
//  Utilities.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/31/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+(void)displayError:(NSString*)errorMsg;
+(void)writeCheckIn:(id<UIAlertViewDelegate>) delegate;
@end
