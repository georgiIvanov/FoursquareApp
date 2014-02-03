//
//  DataSupplier.m
//  FoursquareApp
//
//  Created by Georgi Ivanov on 2/3/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import "DataSupplier.h"

@implementation DataSupplier
{
    NSDictionary* _jsonData;
}
-(instancetype)initWithFile:(NSString*) fileName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:fileName ofType:@"json"];
    
    
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:resource];
    [inputStream open];
    
    NSError* parseError;
    
    _jsonData = [NSJSONSerialization JSONObjectWithStream:inputStream options:NSJSONReadingAllowFragments error:&parseError];
    
    
    [inputStream close];

    return self;
}

-(NSDictionary*)returnJSONData
{
    return _jsonData;
}


@end
