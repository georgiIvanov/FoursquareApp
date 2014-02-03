//
//  ViewController.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestManager.h"

@interface VenuesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *venueTable;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)handleSuccess:(NSDictionary*)responseData;
@end
