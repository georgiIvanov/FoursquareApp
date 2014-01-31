//
//  LoginViewController.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
@interface LoginViewController ()<HttpRequestDelegate, UIWebViewDelegate>

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.webView setDelegate:self];
    [self loadLoginPage];
}

-(void)loadLoginPage
{
    NSURL* url = [NSURL URLWithString:@AUTH_URL];
    
    NSURLRequest* urlReq = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlReq];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.webView = nil;
    
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *URLString = [[self.webView.request URL] absoluteString];
    // NSLog(@"--> %@", URLString);
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"access_token"];
        [defaults synchronize];
        [self dismissViewControllerAnimated:YES completion:^(void){
            
        }];
    }
}


- (IBAction)refreshWindow:(id)sender {
    [self loadLoginPage];
}

-(void)handleSuccess:(NSDictionary *)responseData
{
    
}

-(void)handleError:(NSError *)error
{
    
}
@end
