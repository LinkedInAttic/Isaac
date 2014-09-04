//
//  JSONPersonHelpers.h
//  Isaac
//
//  Created by Peter Livesey on 9/4/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ISCJSONTestPerson : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int intAge;
@property (nonatomic) NSInteger integerAge;
@property (nonatomic) BOOL isCool;
@property (nonatomic, strong) NSArray *favoriteColors;
@property (nonatomic, strong) ISCJSONTestPerson *father;
@property (nonatomic, strong) NSArray *siblings;
@property (nonatomic, strong) NSArray *metaData;

@end
