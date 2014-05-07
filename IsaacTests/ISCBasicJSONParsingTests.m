// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
#import "NSObject+IssacJSONToObject.h"


#pragma mark - Test Person

@interface TestPerson : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int age;
@property (nonatomic, strong) NSNumber *height;

@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) TestPerson *firstBorn;
@property (nonatomic, strong) NSArray *childrenNames;

@property (nonatomic, strong) NSDictionary *additionalData;

@end

#pragma Mark - Tests

@interface ISCBasicJSONParsingTests : XCTestCase

@property (nonatomic, strong) NSDictionary *personJSON;
@property (nonatomic, strong) TestPerson *person;
+ (NSDictionary *)jsonFromString:(NSString *)string;

@end

#pragma mark - Implementation

@implementation ISCBasicJSONParsingTests

- (void)setUp {
  [super setUp];
  
  self.person = [TestPerson new];
  self.person.name = @"Mike";
  self.person.age = 21;
  self.person.height = @165;
  
  TestPerson *firstBorn = [TestPerson new];
  firstBorn.name = @"mikeChild1";
  firstBorn.age = 22;
  firstBorn.height = @205;
  firstBorn.childrenNames = @[ @"mikeGrandchild1", @"mikeGrandchild2" ];
  
  TestPerson *second = [TestPerson new];
  second.name = @"mikeChild2";
  second.age = 24;
  second.height = @225;
  second.childrenNames = @[ @"mikeGrandchild3" ];
  
  self.person.firstBorn = firstBorn;
  self.person.children = @[ firstBorn, second ];
  
  self.personJSON = @{
                      @"name": @"Mike",
                      @"age" : @21,
                      @"height" : @165,
                      @"childrenNames" : @[ @"mikeChild1", @"mikeChild2" ],
                      @"firstBorn" : @{
                          @"name": @"mikeChild1",
                          @"age" : @22,
                          @"height" : @205,
                          @"childrenNames" : @[ @"mikeGrandchild1", @"mikeGrandchild2" ]
                          },
                      @"children" : @[
                          @{
                            @"name": @"mikeChild1",
                            @"age" : @22,
                            @"height" : @205,
                            @"childrenNames" : @[ @"mikeGrandchild1", @"mikeGrandchild2" ]
                            },
                          @{
                            @"name": @"mikeChild2",
                            @"age" : @24,
                            @"height" : @225,
                            @"childrenNames" : @[ @"mikeGrandchild3" ],
                            @"additionalData": @{
                                @"favoriteColor": @"yellow"
                                }
                            }
                          ],
                      @"additionalData": @{
                          @"nickname": @"mikey"
                          }
                      };
}

- (void)testGoodJSON {
  TestPerson *person = [self.personJSON isc_objectFromJSONWithClass:[TestPerson class]];
  
  // Parent properties
  XCTAssertEqualObjects(person.name, @"Mike", @"Name should match");
  XCTAssertEqual(person.age, 21, @"Age should match");
  XCTAssertEqualObjects(person.height, @165, @"Height should match");
  
  // Children names
  XCTAssertEqual([person.childrenNames count], 2u, @"ChildrenNames should have 2 elements");
  XCTAssertEqualObjects(person.childrenNames[0], @"mikeChild1", @"mikeChild1 should match");
  XCTAssertEqualObjects(person.childrenNames[1], @"mikeChild2", @"mikeChild2 should match");
  
  // First born
  XCTAssertNotNil(person.firstBorn, @"First born should not be nil");
  XCTAssertEqual(person.firstBorn.age, 22, @"First born Age should match");
  XCTAssertEqualObjects(person.firstBorn.height, @205, @"First born Height should match");
  XCTAssertEqualObjects(person.firstBorn.name, @"mikeChild1", @"firstborn.name should match");
  XCTAssertNotNil(person.firstBorn.childrenNames, @"person.firstBorn.childrenNames should not be nil");
  XCTAssertEqualObjects(person.firstBorn.childrenNames[0], @"mikeGrandchild1", @"person.firstBorn.childrenNames[0].name should match");
  XCTAssertEqualObjects(person.firstBorn.childrenNames[1], @"mikeGrandchild2", @"person.firstBorn.childrenNames[1].name should match");
  
  // Children
  XCTAssertEqual([person.children count], 2u, @"person.children should have 2 elements");
  XCTAssertNotNil(person.children[0], @"person.children[0] should exist");
  XCTAssertNotNil(person.children[1], @"person.children[1] should exist");
  
  // First child
  XCTAssertEqual(((TestPerson *)person.children[0]).age, 22, @"person.children[0] Age should match");
  XCTAssertEqualObjects(((TestPerson *)person.children[0]).height, @205, @"person.children[0] Height should match");
  XCTAssertEqualObjects(((TestPerson *)person.children[0]).name, @"mikeChild1", @"person.children[0].name should match");
  XCTAssertNotNil(((TestPerson *)person.children[0]).childrenNames, @"person.children[0].childrenNames should not be nil");
  XCTAssertEqualObjects(((TestPerson *)person.children[0]).childrenNames[0], @"mikeGrandchild1", @"person.children[0].childrenNames[0] should match");
  XCTAssertEqualObjects(((TestPerson *)person.children[0]).childrenNames[1], @"mikeGrandchild2", @"person.children[0].childrenNames[1] should match");
  
  // Second child
  XCTAssertEqual(((TestPerson *)person.children[1]).age, 24, @"person.children[1] Age should match");
  XCTAssertEqualObjects(((TestPerson *)person.children[1]).height, @225, @"person.children[1] Height should match");
  XCTAssertEqualObjects(((TestPerson *)person.children[1]).name, @"mikeChild2", @"person.children[1].name should match");
  XCTAssertNotNil(((TestPerson *)person.children[1]).childrenNames, @"person.children[1].childrenNames should not be nil");
  XCTAssertEqualObjects(((TestPerson *)person.children[1]).childrenNames[0], @"mikeGrandchild3", @"person.children[1].childrenNames[0] should match");
  
  // Additional Data
  // Additional data isn't parsed into a model. It's just kept as an NSDictionary
  XCTAssertEqualObjects([person.additionalData objectForKey:@"nickname"], @"mikey", @"additional data should exist and be equal to the dictionary passed in");
  XCTAssertEqualObjects([((TestPerson *)person.children[1]).additionalData objectForKey:@"favoriteColor"], @"yellow", @"additional data on child one should exist and be equal to the dictionary passed in");
  XCTAssertNil(((TestPerson *)person.children[0]).additionalData, @"There is no additional data on child 0 so this should be nil");
}

- (void)testEmptyJSON {
  NSDictionary *json  = @{ };
  TestPerson *person = [json isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person, @"Person shouldn't be nil");
}

- (void)testTypeMismatches {
  // Test mismatch for a string field.
  NSDictionary *badJSON = @{ @"name": @[ @"badarray"] };
  TestPerson *person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.name, @"If the name is an array, it should skip.");
  
  badJSON = @{ @"name" : @1234 };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertEqualObjects(@"1234", person.name, @"If the name is a number, it should coerce.");
  
  badJSON = @{ @"name" : @{ @"key" : @"value" } };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.name, @"If the name is an object, it should skip.");
  
  NSString *badJSONString = @" { \"name\" : { \"key\" : \"value\" } }";
  badJSON = [NSJSONSerialization JSONObjectWithData:[badJSONString dataUsingEncoding:NSUTF8StringEncoding]
                                            options:0
                                              error:NULL];
  XCTAssertNotNil(badJSON, @"Error parsing JSON from string");
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.name, @"If the name is false, it should skip.");
  
  // Test mismatch for a primitive number field.
  badJSON = @{ @"age" : @"1234" };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertEqual(0, person.age, @"If the age is a string, it should skip.");
  
  badJSON = @{ @"age" : @{ @"key" : @"value" } };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertEqual(0, person.age, @"If the age is an object, it should skip.");
  
  badJSON = @{ @"age" : @[ @"badarray" ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertEqual(0, person.age, @"If the age is an array, it should skip.");
  
  // Test mismatch for an NSNumber field
  badJSON = @{ @"height" : @"1234" };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.height, @"If the height is a string, it should skip.");
  
  badJSON = @{ @"age" : @{ @"key" : @"value" } };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.height, @"If the height is an object, it should skip.");
  
  badJSON = @{ @"age" : @[ @"badarray" ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.height, @"If the height is an array, it should skip.");
  
  // Test mismatch for an array field
  badJSON = @{ @"childrenNames" : @"1234" };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.childrenNames, @"If the childrenNames is a string, it should skip.");
  
  badJSON = @{ @"childrenNames" : @{ @"key" : @"value" } };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.childrenNames, @"If the childrenNames is an object, it should skip.");
  
  badJSON = @{ @"childrenNames" : @1234 };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.childrenNames, @"If the childrenNames is a number, it should skip.");
  
  // Test mismatch for array of non-custom objects
  badJSON = @{ @"childrenNames" : @[ @1234 ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.childrenNames, @"Children names with number should have created the array.");
  XCTAssertTrue(1 == [person.childrenNames count], @"Children names with number should have 1 element.");
  XCTAssertEqual(1234, [[person.childrenNames objectAtIndex:0] intValue], @"Children names with number should have 1234.");
  
  badJSON = @{ @"childrenNames" : @[ @[ @"badarray" ] ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.childrenNames, @"Children names with array should have been created.");
  XCTAssertTrue(0 == [person.childrenNames count], @"Children names with number should have skipped.");
  
  badJSON = @{ @"childrenNames" : @[ @{ @"key" : @"value" } ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.childrenNames, @"Children names with object without class should have been created.");
  XCTAssertTrue(0 == [person.childrenNames count], @"Children names with object without class should have skipped.");
  
  badJSON = @{ @"childrenNames" : @[ @{ @"key" : @"value" }, @"realname", @[ @"badarray" ] ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.childrenNames, @"Children names with mixture should have been created.");
  XCTAssertTrue(1 == [person.childrenNames count], @"Children names with mixture should have 1 element.");
  XCTAssertEqualObjects(@"realname", person.childrenNames[0], @"Children names with mixture, should have realname.");
  
  // Test mismatch for array of custom objects
  badJSON = @{ @"children" : @[ @1234 ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.children, @"Children with number should have created the array.");
  XCTAssertTrue(0 == [person.children count], @"Children with number should have skipped.");
  
  badJSON = @{ @"children" : @[ @"1234" ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.children, @"Children with number should have created the array.");
  XCTAssertTrue(0 == [person.children count], @"Children with number should have skipped.");
  
  badJSON = @{ @"children" : @[ @[ @"badarray" ] ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.children, @"Children with array should have been created.");
  XCTAssertTrue(0 == [person.children count], @"Children with number should have skipped.");
  
  badJSON = @{ @"children" : @[ @"realname", @{ @"name" : @"realname" }, @[ @"badarray" ] ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.children, @"Children with mixture should have been created.");
  XCTAssertTrue(1 == [person.children count], @"Children with mixture should have 1 element.");
  XCTAssertTrue([person.children[0] isKindOfClass:[TestPerson class]], @"Children with mixture, real child should be a TestPerson");
  XCTAssertEqualObjects(@"realname", ((TestPerson *)person.children[0]).name, @"Children with mixture, child should have realname.");
  
  // Test mismatch for custom objects
  badJSON = @{ @"firstBorn" : @"1234" };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.firstBorn, @"If firstBorn is a string, it should skip.");
  
  badJSON = @{ @"firstBorn" : @[ @[ @"badarray" ] ] };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.firstBorn, @"If firstBorn is an array, it should skip.");
  
  badJSON = @{ @"firstBorn" : @1234 };
  person = [badJSON isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.firstBorn, @"If firstBorn is a number, it should skip.");
}

- (void)testNull {
  // Test a null in the JSON.
  NSString *badJSONString = @" { \"name\" : null }";
  NSDictionary *json = [ISCBasicJSONParsingTests jsonFromString:badJSONString];
  XCTAssertNotNil(json, @"Error parsing JSON from string.");
  TestPerson *person = [json isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.name, @"For null, name should be nil");
  
  badJSONString = @" { \"height\" : null }";
  json = [ISCBasicJSONParsingTests jsonFromString:badJSONString];
  XCTAssertNotNil(json, @"Error parsing json from string.");
  person = [json isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.height, @"For null, height should be nil.");
  
  badJSONString = @" { \"children\" : null }";
  json = [ISCBasicJSONParsingTests jsonFromString:badJSONString];
  XCTAssertNotNil(json, @"Error parsing json from string.");
  person = [json isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.children, @"For null, children should be nil.");
  
  badJSONString = @" { \"firstBorn\" : null }";
  json = [ISCBasicJSONParsingTests jsonFromString:badJSONString];
  XCTAssertNotNil(json, @"Error parsing json from string.");
  person = [json isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNil(person.firstBorn, @"For null, children should be nil.");
  
  badJSONString = @" { \"children\" : [ null ] }";
  json = [ISCBasicJSONParsingTests jsonFromString:badJSONString];
  XCTAssertNotNil(json, @"Error parsing json from string.");
  person = [json isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.children, @"For [null], children should not be nil.");
  XCTAssertTrue([person.children count] == 0, @"For [null], children should be empty.");
  
  badJSONString = @" { \"childrenNames\" : [ null ] }";
  json = [ISCBasicJSONParsingTests jsonFromString:badJSONString];
  XCTAssertNotNil(json, @"Error parsing json from string.");
  person = [json isc_objectFromJSONWithClass:[TestPerson class]];
  XCTAssertNotNil(person.childrenNames, @"For [null], childrenNames should not be nil.");
  XCTAssertTrue([person.childrenNames count] == 0, @"For [null], childrenNames should be empty.");
}

+ (NSDictionary *)jsonFromString:(NSString *)string {
  return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                         options:0
                                           error:NULL];
}

@end

@implementation TestPerson

- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
  if ([key isEqualToString:@"children"]) {
    return [TestPerson class];
  }
  return [super isc_classForObject:object inArrayWithKey:key];
}

@end