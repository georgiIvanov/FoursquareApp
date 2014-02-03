//
//  FoursquareAppTests.m
//  FoursquareAppTests
//
//  Created by Georgi Ivanov on 1/30/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataSupplier.h"
#import "VenuesViewController.h"
@interface VenuesTests : XCTestCase

@end

#define RESPONSE_DATA_PATH "TrendingResponse"
DataSupplier* _dataSupplier;

@implementation VenuesTests
{
    //    DataSupplier* _dataSupplier = [[DataSupplier alloc] initWithFile@RESPONSE_DATA_PATH];
}
+(void)setUp
{
    
    _dataSupplier = [[DataSupplier alloc]initWithFile:@RESPONSE_DATA_PATH];
    
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSDictionary* json = [_dataSupplier returnJSONData];
    XCTAssert(1 == 1, @"FU");
    XCTAssertEqual(1, 1, );
    //    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end