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

#define TEST_PERSON_NAME @"Mike"
#define TEST_PERSON_INT_AGE 31
#define TEST_PERSON_INTEGER_AGE 41
#define TEST_PERSON_IS_COOL YES
#define TEST_PERSON_FAVORITE_COLOR_ARRAY @[@"red", @"blue"]

#define TEST_FATHER_NAME @"Dave"
#define TEST_FATHER_INT_AGE 51
#define TEST_FATHER_INTEGER_AGE 61
#define TEST_FATHER_IS_COOL NO
#define TEST_FATHER_FAVORITE_COLOR_ARRAY @[@"green", @"yellow"]

#define TEST_SIBLING_NAME @"Dan"
#define TEST_SIBLING_INT_AGE 11
#define TEST_SIBLING_INTEGER_AGE 21
#define TEST_SIBLING_IS_COOL NO
#define TEST_SIBLING_FAVORITE_COLOR_ARRAY @[@"purple", @"pink"]


@interface ISCJSONTestPerson : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int intAge;
@property (nonatomic) NSInteger integerAge;
@property (nonatomic) BOOL isCool;
@property (nonatomic, strong) NSArray *favoriteColors;
@property (nonatomic, strong) ISCJSONTestPerson *father;
@property (nonatomic, strong) NSArray *siblings;

@end

@implementation ISCJSONTestPerson

- (BOOL)isEqual:(id)object {
  ISCJSONTestPerson *other = (ISCJSONTestPerson *)object;
  
  BOOL nameEqual = [self.name isEqual:other.name];
  BOOL intAgeEqual = (self.intAge == other.intAge);
  BOOL integerAgeEqual = (self.integerAge == other.integerAge);
  BOOL isCoolEqual = (self.isCool == other.isCool);
  BOOL favesEqual = (self.favoriteColors == other.favoriteColors ||[self.favoriteColors isEqualToArray:other.favoriteColors]);
  BOOL sibsEqual = (self.siblings == other.siblings || [self.siblings isEqualToArray:other.siblings]);
  
  return (nameEqual &&
          intAgeEqual &&
          integerAgeEqual &&
          isCoolEqual &&
          favesEqual &&
          sibsEqual);
}

- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
  if ([key isEqualToString:@"siblings"]) {
    return [ISCJSONTestPerson class];
  }
  
  return [super isc_classForObject:object inArrayWithKey:key];
}

@end


@interface ISCJSONParsingTests : XCTestCase

@end

@implementation ISCJSONParsingTests

- (void)testPopulateExistingModelObject {
  ISCJSONTestPerson *person = [ISCJSONTestPerson new];
  ISCJSONTestPerson *personToTestAgainst = [self personObject];
  
  NSDictionary *personJSON = [self createTestPersonJSON];
  [personJSON isc_populateJSONIntoModel:person];
  
  XCTAssertTrue(person != nil, @"Person wasn't created.");
  XCTAssertTrue([person isEqual:personToTestAgainst], @"Person doesn't match.");
}

- (void)testDataTypeMismatch {
  NSMutableDictionary *personJSON = [self createTestPersonJSON];
  
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
  ISCJSONTestPerson *person1 = [self personObject];
  ISCJSONTestPerson *person2 = [self personObject];
  
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
  ISCJSONTestPerson *personToTestAgainst = [self personObject];
  
  NSDictionary *personJSON = [self createTestPersonJSON];
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

#pragma mark - Helpers

- (NSMutableDictionary *)createTestPersonJSON {
  return [@{
            @"name": TEST_PERSON_NAME,
            @"intAge": @(TEST_PERSON_INT_AGE),
            @"integerAge": @(TEST_PERSON_INTEGER_AGE),
            @"isCool": @(TEST_PERSON_IS_COOL),
            @"favoriteColors": [TEST_PERSON_FAVORITE_COLOR_ARRAY mutableCopy],
            @"father": [self createTestFatherJSON],
            @"siblings": [@[[self createTestSiblingJSON] ] mutableCopy]
            } mutableCopy];
}

- (NSMutableDictionary *)createTestFatherJSON {
  return [@{
            @"name": TEST_FATHER_NAME,
            @"intAge": @(TEST_FATHER_INT_AGE),
            @"integerAge": @(TEST_FATHER_INTEGER_AGE),
            @"isCool": @(TEST_FATHER_IS_COOL),
            @"favoriteColors": [TEST_FATHER_FAVORITE_COLOR_ARRAY mutableCopy],
            } mutableCopy];
}

- (NSMutableDictionary *)createTestSiblingJSON {
  return [@{
            @"name": TEST_SIBLING_NAME,
            @"intAge": @(TEST_SIBLING_INT_AGE),
            @"integerAge": @(TEST_SIBLING_INTEGER_AGE),
            @"isCool": @(TEST_SIBLING_IS_COOL),
            @"favoriteColors": [TEST_SIBLING_FAVORITE_COLOR_ARRAY mutableCopy],
            } mutableCopy];
}

- (ISCJSONTestPerson *)personObject {
  ISCJSONTestPerson *person = [ISCJSONTestPerson new];
  
  person.name = TEST_PERSON_NAME;
  person.intAge = TEST_PERSON_INT_AGE;
  person.integerAge = TEST_PERSON_INTEGER_AGE;
  person.isCool = TEST_PERSON_IS_COOL;
  person.favoriteColors = TEST_PERSON_FAVORITE_COLOR_ARRAY;
  person.father = [self fatherObject];
  person.siblings = @[[self siblingObject]];
  
  return person;
}

- (ISCJSONTestPerson *)fatherObject {
  ISCJSONTestPerson *person = [ISCJSONTestPerson new];
  
  person.name = TEST_FATHER_NAME;
  person.intAge = TEST_FATHER_INT_AGE;
  person.integerAge = TEST_FATHER_INTEGER_AGE;
  person.isCool = TEST_FATHER_IS_COOL;
  person.favoriteColors = TEST_FATHER_FAVORITE_COLOR_ARRAY;
  
  return person;
}

- (ISCJSONTestPerson *)siblingObject {
  ISCJSONTestPerson *person = [ISCJSONTestPerson new];
  
  person.name = TEST_SIBLING_NAME;
  person.intAge = TEST_SIBLING_INT_AGE;
  person.integerAge = TEST_SIBLING_INTEGER_AGE;
  person.isCool = TEST_SIBLING_IS_COOL;
  person.favoriteColors = TEST_SIBLING_FAVORITE_COLOR_ARRAY;
  
  return person;
}

@end


