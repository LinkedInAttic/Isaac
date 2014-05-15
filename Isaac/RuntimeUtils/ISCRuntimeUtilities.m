// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ISCRuntimeUtilities.h"
#import "ISCRuntimeUtilities+PropertyQuery.h"
// Library
#import <objc/runtime.h>

@implementation ISCRuntimeUtilities

+ (void)enumeratePropertiesForClass:(Class)aClass withBlock:(void(^)(NSString *propertyName, NSString *propertyType, BOOL weakOrAssign))block {
  
  // Go through the properties, and convert them to json.
  unsigned int outCount, i;
  objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
  for(i = 0; i < outCount; i++) {
    objc_property_t property = properties[i];
    const char *propName = property_getName(property);
    if(propName) {
      char *typeEncoding = property_copyAttributeValue(property, "T");
      
      NSString *propertyName = [[NSString alloc] initWithCString:propName encoding:NSASCIIStringEncoding];
      NSString *propertyType = [[NSString alloc] initWithCString:typeEncoding encoding:NSASCIIStringEncoding];
      
      BOOL isWeak = [self propertyIsWeak:property];
      BOOL isAssign = [self propertyIsAssign:property];
      if (block) {
        block(propertyName, propertyType, isWeak || isAssign);
      }
      
      free(typeEncoding);
    }
  }
  free(properties);
}

+ (Class)classForProperty:(NSString *)propertyName inClass:(Class)parentClass {
  Class class = nil;
  
  // Note: This method is very important for JSON parsing so needs to be fast
  // That's why this method is implemented mostly in C
  // Do not convert this char* to an NSString because it will cause a performance degredation
  char *propertyType = [self copyPropertyTypeStringForProperty:propertyName inClass:parentClass];
  
  if (!propertyType) {
    return nil;
  }
  
  if (propertyType[0] == '@') {
    
    if (propertyType[1] == '\0') {
      // The type string is just '@' so it's an NSObject
      class = [NSObject class];
    }
    else {
      // Cache this in a variable so we only need to do this once
      long stringLength = strlen(propertyType);
      if (stringLength > 3) {
        // The type string at this point looks like "@"UIView""
        // The range represents the class name without the @ and quotes. We check the typeString length for safety.
        // If the string is shorter than 3 it definitely doesn't represent an object.
        
        // First, remove the first two characters of the string (@")
        char *classString = propertyType + 2;
        stringLength -= 2;
        // This will shorten the string by one character (we want to remove the " at the end of the string)
        classString[stringLength-1] = '\0';
        class = objc_getClass(classString);
      }
    }
  }
  
  free(propertyType);
  
  return class;
}

+ (char *)copyPropertyTypeStringForProperty:(NSString *)propertyName inClass:(Class)aClass {
  
  objc_property_t property = class_getProperty(aClass, [propertyName UTF8String]);
  
  if (!property) {
    return NULL;
  }
  
  char *typeEncoding = property_copyAttributeValue(property, "T");
  return typeEncoding;
}

@end
