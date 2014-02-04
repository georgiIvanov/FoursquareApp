//
//  VenuesSerializerTests.m
//  
//
//  Created by Georgi Ivanov on 2/4/14.
//
//

#import <XCTest/XCTest.h>
#import "DataSupplier.h"
#import "VenuesSerializer.h"
#import "Venue.h"

DataSupplier* _dataSupplier;
NSDictionary* _recievedVenues;
NSArray* _recievedCategories;

@interface VenuesSerializerTests : XCTestCase <VenuesSerializerDelegate>

@end

@implementation VenuesSerializerTests
{
    VenuesSerializer* _serializer;
    
}

+(void) setUp
{
    _dataSupplier = [[DataSupplier alloc]initWithFile:@RESPONSE_DATA_PATH];
}

-(void)recieveSerializedVenues:(NSDictionary *)venues Categories:(NSArray *)categories
{
    _recievedVenues = venues;
    _recievedCategories = categories;
}

-(Venue*)getVenueByKey:(NSString*) category ObjectAtIndex:(int)index
{
    return [[_recievedVenues objectForKey:category] objectAtIndex:index];
}

-(void)awaitDataSerialization
{
    while(_recievedVenues == nil || _recievedCategories == nil)
    {
        sleep(1);
    }
}

- (void)setUp
{
    [super setUp];
    if(_recievedVenues != nil && _recievedCategories != nil)
    {
        return;
    }
    _serializer  = [VenuesSerializer alloc];
    NSDictionary* json = [_dataSupplier returnJSONData];
    [_serializer loadData:[[json objectForKey:@"response"]
                           objectForKey:@"venues"] ];
    
    __block bool finished = false;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0UL);
    dispatch_time_t threeSeconds = dispatch_time(DISPATCH_TIME_NOW, 2LL * NSEC_PER_SEC);
    dispatch_after(threeSeconds, queue, ^{
        [_serializer serializeVenuesAsync:self];
        [self awaitDataSerialization];
        finished = true;
    });
    
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5];
    while (!finished && [timeout timeIntervalSinceNow]>0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    if (!finished)
    {
        NSLog(@"test failed with timeout");
        XCTFail(@"Test timed out");
    }
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCorrectCategoriesCount
{
    XCTAssert([_recievedCategories count] == 8);
}

-(void)testCorrectVenuesCount
{
    int venueCount = 0;
    for (NSString* key in _recievedVenues) {
        NSArray* arr = [_recievedVenues objectForKey:key];
        venueCount += [arr count];
    }
    
    XCTAssert(venueCount == 9);
}

-(void)testCorrectParsing
{
    Venue* theater = [self getVenueByKey:@"Theaters" ObjectAtIndex:0];
    
    XCTAssert([theater.Name isEqualToString:@"ХаХаХа ИмПро Театър"] == YES);
    XCTAssert([theater.Address isEqualToString:@"ул. Цар Иван Асен II 11"] == YES);
    XCTAssert(theater.Latitude == 42.690266f);
    XCTAssert(theater.Longitude == 23.340561f);
    XCTAssert(theater.Distance == 1184);
    XCTAssert(theater.HereNow == 13);
    XCTAssert([theater.Id isEqualToString:@"50f69da590e728f2108bbbbf"] == YES);
    XCTAssert([theater.Url isEqualToString:@"http://www.facebook.com/hahahaimpro"] == YES);
    
    Venue* jazzClub = [self getVenueByKey:@"Jazz Clubs" ObjectAtIndex:0];
    
    XCTAssert([jazzClub.Name isEqualToString:@"Studio 5"] == YES);
    XCTAssert([jazzClub.Address isEqualToString:@"пл. България 1"] == YES);
    XCTAssert(jazzClub.Latitude == 42.684513f);
    XCTAssert(jazzClub.Longitude == 23.31813f);
    XCTAssert(jazzClub.Distance == 1190);
    XCTAssert(jazzClub.HereNow == 7);
    XCTAssert([jazzClub.Id isEqualToString:@"4d52f7419ffc236a40b532a7"] == YES);
    XCTAssert([jazzClub.Url isEqualToString:@"http://clubstudio5.com"] == YES);

}

@end
