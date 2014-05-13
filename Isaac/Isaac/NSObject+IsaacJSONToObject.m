// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "NSObject+IssacJSONToObject.h"
// Runtime
#import <objc/runtime.h>
// Helpers
#import "ISCRuntimeUtilities.h"
#import "NSObject+IsaacSafeKVO.h"
#import "ISCLog.h"

@implementation NSDictionary (IssacJSONToObject)

- (id)isc_objectFromJSONWithClass:(Class)aClass {
  // If there's no class to create, just return the same object (it's the best we can do).
  if (!aClass) {
    ISCLog(@"Warning: No class given to isc_objectFromJSONWithClass:");
    return self;
  }
  
  NSObject *model = [aClass new];
  NSAssert([model isKindOfClass:[NSObject class]], [NSString stringWithFormat:@""]);
  
  [self isc_populateJSONIntoModel:model];
  
  return model;
}

- (void)isc_populateJSONIntoModel:(NSObject *)model {
  for (NSString *key in self) {
    id jsonValue = [self valueForKey:key];
    [model isc_setJSONValue:jsonValue forJSONKey:key];
  }
}

@end

@interface NSObject (IsaacJSONParsingPrivate)

- (void)isc_setDictionaryJSONValue:(NSDictionary *)jsonValue forObjectKey:(NSString *)objectKey;
- (void)isc_setArrayJSONValue:(NSArray *)jsonValue forObjectKey:(NSString *)objectKey;
- (void)isc_setStringValue:(NSString *)stringValue forObjectKey:(NSString *)objectKey;
- (void)isc_setNumberValue:(NSNumber *)numberValue forObjectKey:(NSString *)objectKey;

@end

@implementation NSObject (IssacJSONToObjectModel)

// This is only here because the compiler was complaining at me. This method should only be called on NSDictionarys.
- (id)isc_objectFromJSONWithClass:(Class)aClass {
  return nil;
}

- (void)isc_setJSONValue:(id)jsonValue forJSONKey:(NSString *)jsonKey {
  NSString *objectKey = [self isc_keyForJSONKey:jsonKey];
  
  if (!objectKey) {
    // A nil key should indicate an intentionally unsupported key.
    // Just silently return without doing anything.
    return;
  }
  
  if ([jsonValue isKindOfClass:[NSDictionary class]]) {
    [self isc_setDictionaryJSONValue:jsonValue forObjectKey:objectKey];
  }
  else if ([jsonValue isKindOfClass:[NSArray class]]) {
    [self isc_setArrayJSONValue:jsonValue forObjectKey:objectKey];
  }
  else if ([jsonValue isKindOfClass:[NSString class]]) {
    [self isc_setStringValue:jsonValue forObjectKey:objectKey];
  }
  else if ([jsonValue isKindOfClass:[NSNumber class]]) {
    [self isc_setNumberValue:jsonValue forObjectKey:objectKey];
  }
  else {
    ISCLog(@"Warning, JSON parser. Unhandled JSON type %@", [jsonValue class]);
  }
}

#pragma mark Type-specific setters

- (void)isc_setDictionaryJSONValue:(NSDictionary *)jsonValue forObjectKey:(NSString *)objectKey {
  Class objectClass = [self isc_classForObjectKey:objectKey];
  
  // By default, the object to set will be a dictionary.
  id object = nil;
  
  // Ensure type safety. If the model object is a dictionary, just set it directly.
  // Otherwise, if the model object is a custom object, parse it.
  // If neither is true, don't set the object.
  if ([objectClass isSubclassOfClass:[NSDictionary class]]) {
    object = jsonValue;
  }
  else if (objectClass &&
           ![objectClass isSubclassOfClass:[NSString class]] &&
           ![objectClass isSubclassOfClass:[NSArray class]] &&
           ![objectClass isSubclassOfClass:[NSNumber class]]) {
    object = [(NSDictionary *)jsonValue isc_objectFromJSONWithClass:objectClass];
  }
  else {
    ISCLog(@"NSObject+IssacJSONToObjectModel warning: Property %@ didn't match dictionary type.", objectKey);
  }
  
  if (object) {
    [self isc_safeSetValue:object forKey:objectKey];
  }
}

// This function puts an NSArray from the JSON into this object - with each
// element in the array parsed itself - but only if the
// object's property is also an array.
- (void)isc_setArrayJSONValue:(NSArray *)jsonValue forObjectKey:(NSString *)objectKey {
  Class objectClass = [self isc_classForObjectKey:objectKey];
  
  // Type safety: Make sure that the model object is also an array.
  if ([objectClass isSubclassOfClass:[NSArray class]]) {
    NSArray *valueArray = (NSArray *)jsonValue;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[valueArray count]];
    
    // For each element in the array, change the JSON to an object.
    // If the array object is another array, drop it (not allowed).
    // If the array object is a dictionary, only allow it if there's an object class.
    // Otherwise just add the object to the array
    for (id arrayElement in valueArray) {
      Class objectClass = [self isc_classForObject:arrayElement inArrayWithKey:objectKey];
      
      id value = nil;
      
      if ([arrayElement isKindOfClass:[NSArray class]] ||
          [arrayElement isKindOfClass:[NSNull class]]) {
        // Do nothing.
        ISCLog(@"isc_setArrayJSONValue:forObjectKey: warning: %@ was ignored because Isaac does not support NSArrays having NSArray or NSNull elements.", arrayElement);
      }
      else if ([arrayElement isKindOfClass:[NSDictionary class]]) {
        if (objectClass) {
          value = [(NSDictionary *)arrayElement isc_objectFromJSONWithClass:objectClass];
        }
        else {
          ISCLog(@"isc_setArrayJSONValue:forObjectKey: warning: element %@ was ignored because it does not have a valid model class.", arrayElement);
        }
      }
      else {
        // Only set the value if it is not supposed to be another class.
        if (!objectClass) {
          value = arrayElement;
        }
      }
      
      if (value) {
        [array addObject:value];
      }
    }
    
    [self isc_safeSetValue:array forKey:objectKey];
  }
  else if (objectClass) {
    // Don't log if there's no variable matching the array. Only if there's a different type.
    ISCLog(@"isc_setArrayJSONValue:forObjectKey: warning: Property %@ didn't match JSON array type.", objectKey);
  }
}

// This function puts an NSString from the JSON into this object, but only if the
// object's property is also a string
- (void)isc_setStringValue:(NSString *)stringValue forObjectKey:(NSString *)objectKey {
  const char *typeEncoding = [ISCRuntimeUtilities copyPropertyTypeStringForProperty:objectKey inClass:[self class]];
  
  if (!typeEncoding) {
    // Couldn't get a type. Probably the property doesn't exist.
    return;
  }
  
  // The object will be set only if the property is a string property.
  switch (typeEncoding[0]) {
    case '@': {
      // It's an object. Check if the type matches.
      Class objectClass = [ISCRuntimeUtilities classForProperty:objectKey inClass:[self class]];
      if ([objectClass isSubclassOfClass:[NSString class]]) {
        [self isc_safeSetValue:stringValue forKey:objectKey];
      }
      else {
        ISCLog(@"isc_setStringValue:forObjectKey: warning: unrecognized object %@ of type %@", stringValue, objectClass);
      }
    }
      break;
    default:
      // It's not a recognized mapping. Fail silently.
      ISCLog(@"NSObject+IssacJSONToObjectModel warning: Cannot map string for key %@ with encoding %s", objectKey, typeEncoding);
      break;
  }
  
  free((char *)typeEncoding);
}

// This function puts an NSNumber from the JSON into this object, but only if the
// object's property is an appropriate type.
- (void)isc_setNumberValue:(NSNumber *)numberValue forObjectKey:(NSString *)objectKey {
  char *typeEncoding = [ISCRuntimeUtilities copyPropertyTypeStringForProperty:objectKey inClass:[self class]];
  
  if (!typeEncoding) {
    // Couldn't get a type. Probably the property doesn't exist.
    return;
  }
  
  // Number will be set if the property is any numeric type, an NSNumber, or NSString (for convenience).
  switch (typeEncoding[0]) {
    case '@': {
      // It's an object. Check if the type matches.
      Class objectClass = [ISCRuntimeUtilities classForProperty:objectKey inClass:[self class]];
      if ([objectClass isSubclassOfClass:[NSNumber class]]) {
        [self isc_safeSetValue:numberValue forKey:objectKey];
      }
      else if ([objectClass isSubclassOfClass:[NSString class]]) {
        [self isc_safeSetValue:[numberValue stringValue] forKey:objectKey];
      }
      else {
        ISCLog(@"isc_setNumberValue:forObjectKey: warning: unrecognized object %@ of type %@", numberValue, objectClass);
      }
    }
      break;
    case 'i': // int
    case 's': // short
    case 'l': // long
    case 'q': // long long
    case 'I': // unsigned int
    case 'S': // unsigned short
    case 'L': // unsigned long
    case 'Q': // unsigned long long
    case 'f': // float
    case 'd': // double
    case 'B': // BOOL
    case 'c': // char
      // We can safely set an NSNumber to any primitive number, and objc will do the right thing.
      [self isc_safeSetValue:numberValue forKey:objectKey];
      break;
      
    default:
      // It's not a recognized mapping. Fail silently.
      ISCLog(@"NSObject+IssacJSONToObjectModel warning: Cannot map number for key %@ with encoding %s", objectKey, typeEncoding);
      break;
  }
  
  free(typeEncoding);
}

#pragma mark - Default Implementations

// By default, just return the same key
- (NSString *)isc_keyForJSONKey:(NSString *)jsonKey {
  return jsonKey;
}

- (Class)isc_classForObjectKey:(NSString *)objectKey {
  // Let's try to find out what type of object to use.
  // Can we get the class directly from the property?
  Class objectClass = [ISCRuntimeUtilities classForProperty:objectKey inClass:[self class]];
  return objectClass;
}

- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
  // By default, return nil which will use the JSON object without any transformation.
  return nil;
}

@end
