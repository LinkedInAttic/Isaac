// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "NSObject+IsaacObjectToJSON.h"

// Utilities
#import "ISCRuntimeUtilities.h"
// Helpers
#import "ISCLog.h"


@implementation NSObject (IsaacObjectToJSON)

- (id)isc_jsonRepresentation {
  // Go through the class stack and enumerate the properties for each class.
  Class currentClass = [self class];
  
  NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
  
  while (currentClass && currentClass != [NSObject class]) {
    // For each class, for each property, get the value of the property and put it in the JSON.
    [ISCRuntimeUtilities enumeratePropertiesForClass:currentClass withBlock:^(NSString *propertyName, NSString *propertyType, BOOL weak) {
      // Check if it's weak
      // If it's weak, let's avoid it because it's likely to lead to a cycle.
      if (!weak) {
        @try {
          // Note that KVC is our friend here. valueForKey: works for all types, and will always return
          // an objective C object. Primitives will be turned into NSNumbers.
          id propertyJSON = [[self valueForKey:propertyName] isc_jsonRepresentation];
          if (propertyJSON) {
            [jsonDictionary setObject:propertyJSON forKey:propertyName];
          }
        }
        @catch (NSException *exception) {
          // This catches structs and makes sure we don't parse them.
          ISCLog(@"Exception: %@", exception);
        }
      }
    }];
    currentClass = [currentClass superclass];
  }
  
  return jsonDictionary;
}

@end

@implementation NSString (IsaacObjectToJSON)

- (NSString *)isc_jsonRepresentation {
  return self;
}

@end

@implementation NSArray (IsaacObjectToJSON)

- (NSArray *)isc_jsonRepresentation {
  NSMutableArray *jsonItems = [NSMutableArray arrayWithCapacity:[self count]];
  for (id collectionItem in self) {
    id jsonItem = [collectionItem isc_jsonRepresentation];
    if (jsonItem) {
      [jsonItems addObject:jsonItem];
    }
  }
  
  return jsonItems;
}

@end

@implementation NSDictionary (IsaacObjectToJSON)

// Wrap the key-value pairs with {}, and put colons within the pairs and commas between pairs.
- (NSDictionary *)isc_jsonRepresentation {
  NSMutableDictionary *jsonItems = [NSMutableDictionary dictionaryWithCapacity:[self count]];
  for (id dictionaryKey in [self allKeys]) {
    id jsonItem = [self[dictionaryKey] isc_jsonRepresentation];
    if (jsonItem) {
      [jsonItems setObject:jsonItem forKey:dictionaryKey];
    }
  }
  return jsonItems;
}

@end

@implementation NSNumber (IsaacObjectToJSON)

- (NSNumber *)isc_jsonRepresentation {
  return self;
}

@end
