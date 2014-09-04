//
//  JSONPersonHelpers.h
//  Isaac
//
//  Created by Peter Livesey on 9/4/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TEST_PERSON_NAME @"Mike"
#define TEST_PERSON_INT_AGE 31
#define TEST_PERSON_INTEGER_AGE 41
#define TEST_PERSON_IS_COOL YES
#define TEST_PERSON_FAVORITE_COLOR_ARRAY @[@"red", @"blue"]
#define TEST_PERSON_META_DATA @[@{@"meta": @"So meta"}, @{}]

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

@class ISCJSONTestPerson;

@interface JSONPersonHelpers : NSObject

+ (NSMutableDictionary *)createTestPersonJSON;

+ (NSMutableDictionary *)createTestFatherJSON;

+ (NSMutableDictionary *)createTestSiblingJSON;

+ (ISCJSONTestPerson *)personObject;

+ (ISCJSONTestPerson *)fatherObject;

+ (ISCJSONTestPerson *)siblingObject;

@end
