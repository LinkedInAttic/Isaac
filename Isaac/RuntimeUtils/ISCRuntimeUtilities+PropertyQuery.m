// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ISCRuntimeUtilities+PropertyQuery.h"

@implementation ISCRuntimeUtilities (PropertyQuery)

+ (BOOL)property:(objc_property_t)property hasPropertyType:(char *)encoding {
  char *attribute = property_copyAttributeValue(property, encoding);
  BOOL hasEncoding = attribute != NULL;
  free(attribute);
  return hasEncoding;
}

+ (BOOL)propertyIsObject:(objc_property_t)property {
  char *attribute = property_copyAttributeValue(property, "T");
  BOOL isObject = attribute[0] == '@';
  free(attribute);
  return isObject;
}

+ (BOOL)propertyIsWeak:(objc_property_t)property {
  return [self property:property hasPropertyType:"W"];
}

+ (BOOL)propertyIsStrong:(objc_property_t)property {
  return [self property:property hasPropertyType:"&"];
}

+ (BOOL)propertyIsCopy:(objc_property_t)property {
  return [self property:property hasPropertyType:"C"];
}

+ (BOOL)propertyIsAssign:(objc_property_t)property {
  // There is no specific encoding for this.
  // We assume it's assign if its an object, and isn't retain or strong
  BOOL isWeak = [self propertyIsWeak:property];
  BOOL isObject = [self propertyIsObject:property];
  BOOL isStrongOrCopy = [self propertyIsStrong:property] || [self propertyIsCopy:property];
  return  isObject && !isWeak && !isStrongOrCopy;
}

@end
