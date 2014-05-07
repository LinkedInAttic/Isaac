// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
#import <CoreGraphics/CoreGraphics.h>
#import "NSObject+IsaacCopyModel.h"


@interface ISCDeepCopyModelTests : XCTestCase

@end

@interface ISCDeepCopyTestObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id objAge;
@property (nonatomic, strong) id nilName;
@property (nonatomic, weak) ISCDeepCopyTestObject *parent;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic) int age;
@property (nonatomic) BOOL groovy;
@property (nonatomic, strong) NSDictionary *extraInfo;
@property (nonatomic) CGPoint favoritePoint;
@property (nonatomic) char favoriteLetter;

@end

@implementation ISCDeepCopyModelTests

- (void)testBasicCopy
{
  ISCDeepCopyTestObject *original = [self testObject];
  [self validateTestObject:original];
  ISCDeepCopyTestObject *copy = [original isc_deepCopyModel];
  [self validateTestObject:copy];
  
  XCTAssertNotEqual(copy, original, @"Shouldn't be the same pointer");
  XCTAssertNotEqual(copy.extraInfo, original.extraInfo, @"Shouldn't be the same pointer");
}

- (void)testNestedCopy
{
  ISCDeepCopyTestObject *original = [self testObject];
  [self validateTestObject:original];
  ISCDeepCopyTestObject *child1 = [self testObject];
  [self validateTestObject:child1];
  ISCDeepCopyTestObject *child2 = [self testObject];
  [self validateTestObject:child2];
  ISCDeepCopyTestObject *gchild = [self testObject];
  [self validateTestObject:gchild];
  
  original.children = @[child1, child2];
  child1.parent = original;
  child2.parent = original;
  
  child1.children = @[ gchild ];
  gchild.parent = child1;
  
  ISCDeepCopyTestObject *copy = [original isc_deepCopyModel];
  [self validateTestObject:copy];
  [self validateTestObject:copy.children[0]];
  [self validateTestObject:copy.children[1]];
  [self validateTestObject:((ISCDeepCopyTestObject *)copy.children[0]).children[0]];
  
  XCTAssertNotEqual(copy, original, @"Shouldn't be the same pointer");
  XCTAssertNotEqual(copy.extraInfo, original.extraInfo, @"Shouldn't be the same pointer");
  XCTAssertNotEqual(copy.children[0], original.children[0], @"Shouldn't be the same pointer");
  XCTAssertNotEqual(copy.children[1], original.children[1], @"Shouldn't be the same pointer");
  XCTAssertNotEqual(((ISCDeepCopyTestObject *)copy.children[0]).children[0], ((ISCDeepCopyTestObject *)original.children[0]).children[0], @"Shouldn't be the same pointer");
}

- (ISCDeepCopyTestObject *)testObject
{
  ISCDeepCopyTestObject *original = [[ISCDeepCopyTestObject alloc] init];
  original.name = @"test";
  original.objAge = @(25);
  original.nilName = nil;
  original.age = 4;
  original.groovy = YES;
  original.extraInfo = @{@"hello": @"world"};
  original.favoritePoint = CGPointMake(3, 4);
  original.favoriteLetter = 'e';
  return original;
}

- (void)validateTestObject:(ISCDeepCopyTestObject *)testObject
{
  XCTAssertEqualObjects(testObject.name, @"test", @"Should be correct");
  XCTAssertEqualObjects(testObject.objAge, @(25), @"Should be correct");
  XCTAssertNil(testObject.nilName, @"Should be correct");
  XCTAssertEqual(testObject.age, 4, @"Should be correct");
  XCTAssertEqual(testObject.groovy, YES, @"Should be correct");
  XCTAssertEqualObjects(testObject.extraInfo, @{@"hello": @"world"}, @"Should be correct");
  XCTAssertEqualObjects([testObject.extraInfo objectForKey:@"hello"], @"world", @"Should be correct");
  XCTAssertEqual((NSInteger)testObject.favoritePoint.x, 3, @"Should be correct");
  XCTAssertEqual((NSInteger)testObject.favoritePoint.y, 4, @"Should be correct");
  XCTAssertTrue(testObject.favoriteLetter == 'e', @"Should be correct");
}

@end

@implementation ISCDeepCopyTestObject

@end
