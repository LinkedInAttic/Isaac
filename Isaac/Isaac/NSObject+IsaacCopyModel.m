// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "NSObject+IsaacCopyModel.h"
// Helpers
#import "ISCRuntimeUtilities.h"
#import "NSObject+IsaacSafeKVO.h"


@implementation NSObject (IsaacCopyModel)

- (instancetype)isc_deepCopyModel {
  
  // If we can do a regular copy, let's do it
  if ([self conformsToProtocol:@protocol(NSCopying)]) {
    return [self copy];
  }
  else {
    // Otherwise, we'll do our own custom deep copy
    // Create a new instance of the current object
    id copy = [[[self class] alloc] init];
    
    [ISCRuntimeUtilities enumeratePropertiesForClass:[self class]
                                            withBlock:^(NSString *propertyName, NSString *propertyType, BOOL weakOrAssign) {
                                              // Get the value of the property
                                              id propertyValue = [self valueForKey:propertyName];
                                              
                                              // Use safe for both these cases because it's possible that the property may not be KVO compliant
                                              // For any models you should run this on, this won't be a problem. But I like never crashing.
                                              if (weakOrAssign) {
                                                // This is a little strange, but it helps avoid cycles
                                                // If it is weak, we don't want to create a copy because otherwise, we'll cycle in creating copies
                                                // Basically, this is assuming that if this is a weak reference we have already copied this object previously in the recursion
                                                [copy isc_safeSetValue:propertyValue forKey:propertyName];
                                              } else {
                                                [copy isc_safeSetValue:[propertyValue isc_deepCopyModel] forKey:propertyName];
                                              }
                                            }];
    return copy;
  }
}

@end

@implementation NSArray (IsaacCopyModel)

// For arrays, we want to do a deep copy to ensure that all models are new models
// The copy method returns a shallow copy so we can't use it here
- (instancetype)isc_deepCopyModel {
  NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:[self count]];
  for (id object in self) {
    id newObject = [object isc_deepCopyModel];
    [newArray addObject:newObject];
  }
  return newArray;
}

@end

@implementation NSDictionary (IsaacCopyModel)

// For dictionaries, we want to do a deep copy to ensure that all models are new models
// The copy method returns a shallow copy so we can't use it here
- (instancetype)isc_deepCopyModel {
  NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithCapacity:[self count]];
  for (id<NSCopying> key in [self allKeys]) {
    id currentObject = [self objectForKey:key];
    id newObject = [currentObject isc_deepCopyModel];
    [newDictionary setObject:newObject forKey:key];
  }
  return newDictionary;
}

@end

