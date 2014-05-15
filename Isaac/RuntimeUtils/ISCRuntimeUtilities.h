// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

@interface ISCRuntimeUtilities : NSObject

/*!
 For a given class, get all properties. Note that it will not get properties of the superclass(es).
 For each property, call the block.
 Property type looks like @"<class_name>" for classes (with @ and quotes in the string) (ie. @"NSString")
    and single characters for primitives (no quotes or @) (ie. c)
 For structs, the property type looks a little strange. For example, for a CGPoint, it looks like @"{CGPoint=ff}"
 */
+ (void)enumeratePropertiesForClass:(Class)aClass withBlock:(void(^)(NSString *propertyName, NSString *propertyType, BOOL weak))block;

/*!
 For a parent class and the name of a property, get a class object for the property's type.
 \param propertyName Required. The name of the property.
 \param aClass Required. The class in which the property is defined.
 \returns The class for the property, or nil if the property doesn't exist, or is a primitive.
 */
+ (Class)classForProperty:(NSString *)propertyName inClass:(Class)parentClass;

/*!
 Get the runtime type string for a given property. Type strings are c-strings like "@\"NSString\"" for object, "i" for int, "c" for char (or BOOL), etc.
 \param propertyName Required. The name of the property.
 \param aClass Required. The class in which the property is defined.
 \returns A c-string with the type of the property. Possible values: "@\"<Class_name>\"", "i", "c"
 \discussion You must call free() on the returned string. The memory is not managed for you.
    Object return types are in an odd format: The first character is '@'. Then it will be the name of the class, wrapped in quotations '"'
    This allows a caller to instantiate a variable of the correct type. 
    Examples: 
        NSString type will be "@\"NSString\"" (The outer quotes are not part of the type string.)
        int type will be "i"
        NSMutableArray will be "@\"NSMutableArray\""
 */
+ (char *)copyPropertyTypeStringForProperty:(NSString *)propertyName inClass:(Class)aClass;

@end
