// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>

#import "NSObject+IsaacObjectToJSON.h"
#import <UIKit/UIKit.h>
#import "NSObject+IssacJSONToObject.h"


@interface ISCJSONSerializationTestPerson : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int age;
@property (nonatomic, strong) NSNumber *height;

@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) ISCJSONSerializationTestPerson *firstBorn;
@property (nonatomic, strong) NSArray *childrenNames;

@property (nonatomic, strong) NSDictionary *extraInfo;

@property (nonatomic) char letter;

@property (nonatomic, weak) ISCJSONSerializationTestPerson *parent;

@end

@implementation ISCJSONSerializationTestPerson

@end

@interface ISCJSONSerializationTests : XCTestCase
@property (nonatomic, strong) ISCJSONSerializationTestPerson *person;

@end

@implementation ISCJSONSerializationTests

- (void)setUp {
  [super setUp];
  
  // 1
  self.person = [ISCJSONSerializationTestPerson new];
  self.person.name = @"Mike";
  self.person.age = 21;
  self.person.height = @165;
  self.person.extraInfo = @{
                            @"favorite": @"waffles"
                            };
  // As per the spec, this will be converted into a BOOL
  self.person.letter = 'p';
  
  // 2
  ISCJSONSerializationTestPerson *firstBorn = [ISCJSONSerializationTestPerson new];
  firstBorn.name = @"mikeChild1";
  firstBorn.age = 22;
  firstBorn.height = @205;
  firstBorn.childrenNames = @[ @"mikeGrandchild1", @"mikeGrandchild2" ];
  // Add a circular reference. Should work fine.
  firstBorn.parent = self.person;
  
  // 3
  ISCJSONSerializationTestPerson *second = [ISCJSONSerializationTestPerson new];
  second.name = @"mikeChild2";
  second.age = 24;
  second.height = @225;
  second.childrenNames = @[ @"mikeGrandchild3" ];
  firstBorn.parent = self.person;
  
  self.person.firstBorn = firstBorn;
  self.person.children = @[ firstBorn, second ];
  
}

- (void)testObjectStrings {
  NSDictionary *personJSON = [self.person isc_jsonRepresentation];
  
  // 1
  XCTAssertEqualObjects([personJSON objectForKey:@"name"], @"Mike", @"Properties should be the same as the setup");
  XCTAssertEqualObjects([personJSON objectForKey:@"age"], @21, @"Properties should be the same as the setup");
  XCTAssertEqualObjects([personJSON objectForKey:@"height"], @165, @"Properties should be the same as the setup");
  XCTAssertEqualObjects([[personJSON objectForKey:@"extraInfo"] objectForKey:@"favorite"], @"waffles", @"Properties should be the same as the setup");
  XCTAssertEqualObjects([personJSON objectForKey:@"letter"], @('p'), @"Properties should be the same as the setup");
  
  // 2
  XCTAssertEqualObjects([[[personJSON objectForKey:@"children"] objectAtIndex:0] objectForKey:@"name"], @"mikeChild1", @"Properties should be the same as the setup");
  XCTAssertEqualObjects([[[personJSON objectForKey:@"children"] objectAtIndex:0] objectForKey:@"age"], @22, @"Properties should be the same as the setup");
  XCTAssertEqualObjects([[[personJSON objectForKey:@"children"] objectAtIndex:0] objectForKey:@"height"], @205, @"Properties should be the same as the setup");
  NSArray *childrenArray = @[ @"mikeGrandchild1", @"mikeGrandchild2" ];
  XCTAssertEqualObjects([[[personJSON objectForKey:@"children"] objectAtIndex:0] objectForKey:@"childrenNames"], childrenArray, @"Properties should be the same as the setup");
  XCTAssertNil([[[personJSON objectForKey:@"children"] objectAtIndex:0] objectForKey:@"parent"], @"Properties should be the same as the setup");
  
  // 3
  XCTAssertEqualObjects([[[personJSON objectForKey:@"children"] objectAtIndex:1] objectForKey:@"name"], @"mikeChild2", @"Properties should be the same as the setup");
  XCTAssertEqualObjects([[[personJSON objectForKey:@"children"] objectAtIndex:1] objectForKey:@"age"], @24, @"Properties should be the same as the setup");
  XCTAssertEqualObjects([[[personJSON objectForKey:@"children"] objectAtIndex:1] objectForKey:@"height"], @225, @"Properties should be the same as the setup");
  childrenArray = @[ @"mikeGrandchild3" ];
  XCTAssertEqualObjects([[[personJSON objectForKey:@"children"] objectAtIndex:1] objectForKey:@"childrenNames"], childrenArray, @"Properties should be the same as the setup");
  XCTAssertNil([[[personJSON objectForKey:@"children"] objectAtIndex:1] objectForKey:@"parent"], @"Properties should be the same as the setup");
}


@end
