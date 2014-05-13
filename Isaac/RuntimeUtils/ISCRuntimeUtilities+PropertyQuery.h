// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ISCRuntimeUtilities.h"
#import <objc/runtime.h>


@interface ISCRuntimeUtilities (PropertyQuery)

/*!
 Structs and primitives are not objects. Everything that can be an id is an object.
*/
+ (BOOL)propertyIsObject:(objc_property_t)property;

/*!
 Returns if the property is declared with weak.
 */
+ (BOOL)propertyIsWeak:(objc_property_t)property;

/*!
 Returns if the property is declared with strong or retain. There is no way to differenciate strong with retain as they are the same.
 */
+ (BOOL)propertyIsStrong:(objc_property_t)property;

/*!
 Returns if property is declared with copy.
 */
+ (BOOL)propertyIsCopy:(objc_property_t)property;

/*!
 Returns if property is declared with assign. Weak properties are not assign. This will also return YES if the property is unsafe_unretained.
 
 This cannot be explicitly queried. Instead, it checks if it is an object and it is not weak, strong or retain.
 */
+ (BOOL)propertyIsAssign:(objc_property_t)property;

@end
