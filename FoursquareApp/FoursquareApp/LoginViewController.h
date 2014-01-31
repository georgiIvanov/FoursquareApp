//
//  LoginViewController.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestManager.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)refreshWindow:(id)sender;



-(void)handleSuccess:(NSDictionary*)responseData;
-(void)handleError:(NSError*)error;

@end
