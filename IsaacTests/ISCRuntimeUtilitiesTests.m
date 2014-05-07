// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>

#import "ISCRuntimeUtilities.h"

@interface ISCRuntimeTestPerson : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int intAge;
@property (nonatomic) NSInteger integerAge;
@property (nonatomic) BOOL isCool;
@property (nonatomic, strong) NSArray *favoriteColors;
@property (nonatomic, strong) ISCRuntimeTestPerson *father;

@end

@implementation ISCRuntimeTestPerson

@end

@interface ISCRuntimeUtilitiesTests : XCTestCase

@end

@implementation ISCRuntimeUtilitiesTests

- (void)testPropertyTypes {
  const char *type = NULL;
  
  type = [ISCRuntimeUtilities copyPropertyTypeStringForProperty:@"name" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(strcmp(type, "@\"NSString\"") == 0, @"Type doesn't match.");
  free((char *)type);
  
  type = [ISCRuntimeUtilities copyPropertyTypeStringForProperty:@"intAge" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(strcmp(type, "i") == 0, @"Type doesn't match.");
  free((char *)type);
  
  type = [ISCRuntimeUtilities copyPropertyTypeStringForProperty:@"integerAge" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(strcmp(type, "i") == 0, @"Type doesn't match.");
  free((char *)type);
  
  type = [ISCRuntimeUtilities copyPropertyTypeStringForProperty:@"isCool" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(strcmp(type, "c") == 0, @"Type doesn't match.");
  free((char *)type);
  
  type = [ISCRuntimeUtilities copyPropertyTypeStringForProperty:@"favoriteColors" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(strcmp(type, "@\"NSArray\"") == 0, @"Type doesn't match.");
  free((char *)type);
  
  type = [ISCRuntimeUtilities copyPropertyTypeStringForProperty:@"father" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(strcmp(type, "@\"ISCRuntimeTestPerson\"") == 0, @"Type doesn't match.");
  free((char *)type);
}

- (void)testPropertyClasses {
  Class propertyClass = nil;
  
  propertyClass = [ISCRuntimeUtilities classForProperty:@"name" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(propertyClass == [NSString class], @"Wrong class");
  
  propertyClass = [ISCRuntimeUtilities classForProperty:@"intAge" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(propertyClass == nil, @"Wrong class");
  
  propertyClass = [ISCRuntimeUtilities classForProperty:@"integerAge" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(propertyClass == nil, @"Wrong class");
  
  propertyClass = [ISCRuntimeUtilities classForProperty:@"isCool" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(propertyClass == nil, @"Wrong class");
  
  propertyClass = [ISCRuntimeUtilities classForProperty:@"favoriteColors" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(propertyClass == [NSArray class], @"Wrong class");
  
  propertyClass = [ISCRuntimeUtilities classForProperty:@"father" inClass:[ISCRuntimeTestPerson class]];
  XCTAssertTrue(propertyClass == [ISCRuntimeTestPerson class], @"Wrong class");
}

- (void)testPropertyEnumeration {
  NSMutableArray *properties = [NSMutableArray new];
  NSMutableArray *types = [NSMutableArray new];
  [ISCRuntimeUtilities enumeratePropertiesForClass:[ISCRuntimeTestPerson class] withBlock:^(NSString *propertyName, NSString *propertyType, BOOL weak) {
    [properties addObject:propertyName];
    [types addObject:propertyType];
  }];
  
  XCTAssertTrue([properties containsObject:@"name"], @"Missing property");
  XCTAssertTrue([properties containsObject:@"intAge"], @"Missing property");
  XCTAssertTrue([properties containsObject:@"integerAge"], @"Missing property");
  XCTAssertTrue([properties containsObject:@"isCool"], @"Missing property");
  XCTAssertTrue([properties containsObject:@"favoriteColors"], @"Missing property");
  XCTAssertTrue([properties containsObject:@"father"], @"Missing property");
  
  XCTAssertTrue([types[[properties indexOfObject:@"name"]] isEqualToString:@"@\"NSString\""], @"Wrong type.");
  XCTAssertTrue([types[[properties indexOfObject:@"intAge"]] isEqualToString:@"i"], @"Wrong type.");
  XCTAssertTrue([types[[properties indexOfObject:@"integerAge"]] isEqualToString:@"i"], @"Wrong type.");
  XCTAssertTrue([types[[properties indexOfObject:@"isCool"]] isEqualToString:@"c"], @"Wrong type.");
  XCTAssertTrue([types[[properties indexOfObject:@"favoriteColors"]] isEqualToString:@"@\"NSArray\""], @"Wrong type.");
  XCTAssertTrue([types[[properties indexOfObject:@"father"]] isEqualToString:@"@\"ISCRuntimeTestPerson\""], @"Wrong type.");
}

@end
