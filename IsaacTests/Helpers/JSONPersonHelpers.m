//
//  JSONPersonHelpers.m
//  Isaac
//
//  Created by Peter Livesey on 9/4/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

#import "JSONPersonHelpers.h"
#import "ISCJSONTestPerson.h"


@implementation JSONPersonHelpers

+ (NSMutableDictionary *)createTestPersonJSON {
  return [@{
            @"name": TEST_PERSON_NAME,
            @"intAge": @(TEST_PERSON_INT_AGE),
            @"integerAge": @(TEST_PERSON_INTEGER_AGE),
            @"isCool": @(TEST_PERSON_IS_COOL),
            @"favoriteColors": [TEST_PERSON_FAVORITE_COLOR_ARRAY mutableCopy],
            @"father": [self createTestFatherJSON],
            @"siblings": [@[[self createTestSiblingJSON] ] mutableCopy],
            @"metaData": [TEST_PERSON_META_DATA mutableCopy]
            } mutableCopy];
}

+ (NSMutableDictionary *)createTestFatherJSON {
  return [@{
            @"name": TEST_FATHER_NAME,
            @"intAge": @(TEST_FATHER_INT_AGE),
            @"integerAge": @(TEST_FATHER_INTEGER_AGE),
            @"isCool": @(TEST_FATHER_IS_COOL),
            @"favoriteColors": [TEST_FATHER_FAVORITE_COLOR_ARRAY mutableCopy],
            } mutableCopy];
}

+ (NSMutableDictionary *)createTestSiblingJSON {
  return [@{
            @"name": TEST_SIBLING_NAME,
            @"intAge": @(TEST_SIBLING_INT_AGE),
            @"integerAge": @(TEST_SIBLING_INTEGER_AGE),
            @"isCool": @(TEST_SIBLING_IS_COOL),
            @"favoriteColors": [TEST_SIBLING_FAVORITE_COLOR_ARRAY mutableCopy],
            } mutableCopy];
}

+ (ISCJSONTestPerson *)personObject {
  ISCJSONTestPerson *person = [ISCJSONTestPerson new];
  
  person.name = TEST_PERSON_NAME;
  person.intAge = TEST_PERSON_INT_AGE;
  person.integerAge = TEST_PERSON_INTEGER_AGE;
  person.isCool = TEST_PERSON_IS_COOL;
  person.favoriteColors = TEST_PERSON_FAVORITE_COLOR_ARRAY;
  person.father = [self fatherObject];
  person.siblings = @[[self siblingObject]];
  person.metaData = TEST_PERSON_META_DATA;
  
  return person;
}

+ (ISCJSONTestPerson *)fatherObject {
  ISCJSONTestPerson *person = [ISCJSONTestPerson new];
  
  person.name = TEST_FATHER_NAME;
  person.intAge = TEST_FATHER_INT_AGE;
  person.integerAge = TEST_FATHER_INTEGER_AGE;
  person.isCool = TEST_FATHER_IS_COOL;
  person.favoriteColors = TEST_FATHER_FAVORITE_COLOR_ARRAY;
  
  return person;
}

+ (ISCJSONTestPerson *)siblingObject {
  ISCJSONTestPerson *person = [ISCJSONTestPerson new];
  
  person.name = TEST_SIBLING_NAME;
  person.intAge = TEST_SIBLING_INT_AGE;
  person.integerAge = TEST_SIBLING_INTEGER_AGE;
  person.isCool = TEST_SIBLING_IS_COOL;
  person.favoriteColors = TEST_SIBLING_FAVORITE_COLOR_ARRAY;
  
  return person;
}

@end
