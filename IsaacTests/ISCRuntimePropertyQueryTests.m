// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
// Runtime
#import "ISCRuntimeUtilities+PropertyQuery.h"
// Framework
#import <CoreGraphics/CoreGraphics.h>


@interface ISCRuntimePropertyQueryTests : XCTestCase

@end

@interface ISCRuntimePropertyQueryTestObject : NSObject

@property (nonatomic, strong) id a;
@property (nonatomic, retain) id b;
@property (nonatomic, copy) id c;
@property (nonatomic, weak) id d;
@property (nonatomic, assign) id e;
@property (nonatomic, unsafe_unretained) id f;
@property (nonatomic) int g;
@property (nonatomic) CGPoint h;

@end

@implementation ISCRuntimePropertyQueryTests

- (void)testIsObject {
  unsigned int outCount;
  objc_property_t *properties = class_copyPropertyList([ISCRuntimePropertyQueryTestObject class], &outCount);
  for(NSUInteger i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    const char *propName = property_getName(property);
    switch (propName[0]) {
      case 'g':
      case 'h':
        XCTAssertFalse([ISCRuntimeUtilities propertyIsObject:property], @"Property should not be an object");
        break;
      default:
        XCTAssertTrue([ISCRuntimeUtilities propertyIsObject:property], @"Property should be an object");
        break;
    }
  }
}

- (void)testIsWeak {
  unsigned int outCount;
  objc_property_t *properties = class_copyPropertyList([ISCRuntimePropertyQueryTestObject class], &outCount);
  for(NSUInteger i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    const char *propName = property_getName(property);
    switch (propName[0]) {
      case 'd':
        XCTAssertTrue([ISCRuntimeUtilities propertyIsWeak:property], @"Property should be weak");
        break;
      default:
        XCTAssertFalse([ISCRuntimeUtilities propertyIsWeak:property], @"Property should not be weak");
        break;
    }
  }
}

- (void)testIsStrong {
  unsigned int outCount;
  objc_property_t *properties = class_copyPropertyList([ISCRuntimePropertyQueryTestObject class], &outCount);
  for(NSUInteger i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    const char *propName = property_getName(property);
    switch (propName[0]) {
      case 'a':
      case 'b':
        XCTAssertTrue([ISCRuntimeUtilities propertyIsStrong:property], @"Property should be strong");
        break;
      default:
        XCTAssertFalse([ISCRuntimeUtilities propertyIsStrong:property], @"Property should not be strong");
        break;
    }
  }
}

- (void)testIsCopy {
  unsigned int outCount;
  objc_property_t *properties = class_copyPropertyList([ISCRuntimePropertyQueryTestObject class], &outCount);
  for(NSUInteger i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    const char *propName = property_getName(property);
    switch (propName[0]) {
      case 'c':
        XCTAssertTrue([ISCRuntimeUtilities propertyIsCopy:property], @"Property should be copy");
        break;
      default:
        XCTAssertFalse([ISCRuntimeUtilities propertyIsCopy:property], @"Property should not be copy");
        break;
    }
  }
}

- (void)testIsAssign {
  unsigned int outCount;
  objc_property_t *properties = class_copyPropertyList([ISCRuntimePropertyQueryTestObject class], &outCount);
  for(NSUInteger i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    const char *propName = property_getName(property);
    switch (propName[0]) {
      case 'e':
      case 'f':
        XCTAssertTrue([ISCRuntimeUtilities propertyIsAssign:property], @"Property should be assign");
        break;
      default:
        XCTAssertFalse([ISCRuntimeUtilities propertyIsAssign:property], @"Property should not be assign");
        break;
    }
  }
}

@end

@implementation ISCRuntimePropertyQueryTestObject

@end
