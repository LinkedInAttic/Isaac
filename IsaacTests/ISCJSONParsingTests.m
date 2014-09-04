// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>

#import "NSObject+IsaacJSONToObject.h"
// Helpers
#import "ISCJSONTestPerson.h"
#import "JSONPersonHelpers.h"


@interface ISCJSONParsingTests : XCTestCase

@end

@implementation ISCJSONParsingTests

- (void)testPopulateExistingModelObject {
  ISCJSONTestPerson *person = [ISCJSONTestPerson new];
  ISCJSONTestPerson *personToTestAgainst = [JSONPersonHelpers personObject];
  
  NSDictionary *personJSON = [JSONPersonHelpers createTestPersonJSON];
  [personJSON isc_populateJSONIntoModel:person];
  
  XCTAssertTrue(person != nil, @"Person wasn't created.");
  XCTAssertTrue([person isEqual:personToTestAgainst], @"Person doesn't match.");
}

- (void)testDataTypeMismatch {
  NSMutableDictionary *personJSON = [JSONPersonHelpers createTestPersonJSON];
  
  personJSON[@"name"] = @[@1];
  personJSON[@"intAge"] = @"hello";
  personJSON[@"integerAge"] = @"hello";
  personJSON[@"isCool"] = @"hello";
  personJSON[@"favoriteColors"] = @"hello";
  personJSON[@"father"] = @"hello";
  
  ISCJSONTestPerson *person = nil;
  
  person = [personJSON isc_objectFromJSONWithClass:[ISCJSONTestPerson class]];
  
  XCTAssertTrue(person.name == nil, @"Name doesn't match.");
  XCTAssertTrue(person.intAge == 0, @"intAge doesn't match.");
  XCTAssertTrue(person.integerAge == 0, @"integerAge doesn't match.");
  XCTAssertTrue(person.isCool == NO, @"isCool doesn't match.");
  XCTAssertTrue(person.favoriteColors == nil, @"favoriteColors doesn't match.");
  XCTAssertTrue(person.father == nil, @"father doesn't match.");
}

- (void)testPersonEquality {
  ISCJSONTestPerson *person1 = [JSONPersonHelpers personObject];
  ISCJSONTestPerson *person2 = [JSONPersonHelpers personObject];
  
  XCTAssertTrue([person1 isEqual:person2], @"People should match.");
  
  person1.name = @"nomatch";
  XCTAssertFalse([person1 isEqual:person2], @"People should not match.");
  
  person1.name = TEST_PERSON_NAME;
  XCTAssertTrue([person1 isEqual:person2], @"People should match.");
  
  person1.intAge = 123;
  XCTAssertFalse([person1 isEqual:person2], @"People should not match.");
  
  person1.intAge = TEST_PERSON_INT_AGE;
  XCTAssertTrue([person1 isEqual:person2], @"People should match.");
  
  person1.integerAge = 123;
  XCTAssertFalse([person1 isEqual:person2], @"People should not match.");
  
  person1.integerAge = TEST_PERSON_INTEGER_AGE;
  XCTAssertTrue([person1 isEqual:person2], @"People should match.");
  
  person1.isCool = NO;
  XCTAssertFalse([person1 isEqual:person2], @"People should not match.");
  
  person1.isCool = TEST_PERSON_IS_COOL;
  XCTAssertTrue([person1 isEqual:person2], @"People should match.");
  
  person1.favoriteColors = @[ @"black" ];
  XCTAssertFalse([person1 isEqual:person2], @"People should not match.");
  
  person1.favoriteColors = TEST_PERSON_FAVORITE_COLOR_ARRAY;
  XCTAssertTrue([person1 isEqual:person2], @"People should match.");
}

- (void)testSimpleParsing {
  ISCJSONTestPerson *person = nil;
  ISCJSONTestPerson *personToTestAgainst = [JSONPersonHelpers personObject];
  
  NSDictionary *personJSON = [JSONPersonHelpers createTestPersonJSON];
  person = [personJSON isc_objectFromJSONWithClass:[ISCJSONTestPerson class]];
  
  XCTAssertTrue(person != nil, @"Person wasn't created.");
  XCTAssertTrue([person isEqual:personToTestAgainst], @"Person doesn't match.");
}

- (void)testEmptyJSON {
  ISCJSONTestPerson *person = nil;
  
  NSDictionary *personJSON = @{};
  person = [personJSON isc_objectFromJSONWithClass:[ISCJSONTestPerson class]];
  
  XCTAssertTrue(person != nil, @"Person wasn't created.");
  XCTAssertTrue(person.name == nil, @"Name doesn't match.");
  XCTAssertTrue(person.favoriteColors == nil, @"Color array doesn't match.");
}

/*
 This test makes sure that if you don't specify a class in an array is just puts the dictionary in as is.
 */
- (void)testDictionariesInArrays {
  NSDictionary *personJSON = [JSONPersonHelpers createTestPersonJSON];
  ISCJSONTestPerson *person = [personJSON isc_objectFromJSONWithClass:[ISCJSONTestPerson class]];
  
  XCTAssertEqual([person.metaData count], 2, @"There should be two objects in this array");
  XCTAssertTrue([person.metaData[0] isKindOfClass:[NSDictionary class]], @"The first object should be a dictionary");
  XCTAssertTrue([person.metaData[1] isKindOfClass:[NSDictionary class]], @"The second object should be a dictionary");
  
  // Macros suck with modern objective-c...
  id firstObjectValue = person.metaData[0][@"meta"];
  id expectedObjectValue = TEST_PERSON_META_DATA[0][@"meta"];
  XCTAssertEqualObjects(firstObjectValue, expectedObjectValue, @"The first object should have the right keys in it");
  
  NSArray *secondObjectKeys = [person.metaData[1] allKeys];
  XCTAssertEqual([secondObjectKeys count], 0, @"The second object should have no keys in it");
}

@end


