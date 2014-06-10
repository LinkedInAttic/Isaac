// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LargeJSONModel.h"
#import "NSObject+IsaacJSONToObject.h"
#import "PerformancePersonModel.h"


@implementation LargeJSONModel

- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
  return [PerformancePersonModel class];
}

- (void)setupWithData:(NSDictionary *)data {
  // Look how annoying this code is to write...
  
  NSMutableArray *modelValues = [NSMutableArray array];
  NSArray *values = data[@"values"];
  if ([values isKindOfClass:[NSArray class]]) {
    for (NSDictionary *dictionary in values) {
      if ([dictionary isKindOfClass:[NSDictionary class]]) {
        PerformancePersonModel *person = [[PerformancePersonModel alloc] init];
        [person setupWithData:dictionary];
        [modelValues addObject:person];
      }
    }
  }
  self.values = modelValues;
}

@end
