// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "PerformanceFriendModel.h"

@implementation PerformanceFriendModel

- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
  return [PerformanceFriendModel class];
}

- (void)setupWithData:(NSDictionary *)data {
  if ([data[@"name"] isKindOfClass:[NSString class]]) {
    self.name = data[@"name"];
  }
  
  // This is the worst! If only someone would make a library so I don't need to write this code...
  NSMutableArray *modelValues = [NSMutableArray array];
  NSArray *values = data[@"friends"];
  if ([values isKindOfClass:[NSArray class]]) {
    for (NSDictionary *dictionary in values) {
      if ([dictionary isKindOfClass:[NSDictionary class]]) {
        PerformanceFriendModel *person = [[PerformanceFriendModel alloc] init];
        [person setupWithData:dictionary];
        [modelValues addObject:person];
      }
    }
  }
  self.friends = modelValues;
}

@end
