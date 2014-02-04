//
//  DataSupplier.h
//  FoursquareApp
//
//  Created by Georgi Ivanov on 2/3/14.
//  Copyright (c) 2014 Georgi Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileNames.h"

@interface DataSupplier : NSObject

-(instancetype)initWithFile:(NSString*) fileName;
-(NSDictionary*)returnJSONData;
@end
