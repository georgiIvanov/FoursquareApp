//
//  ViewController.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestManager.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *venueTable;

-(void)handleSuccess:(NSDictionary*)responseData;
-(void)handleError:(NSError*)error;



@end
