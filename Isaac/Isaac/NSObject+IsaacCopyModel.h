// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

@interface NSObject (IsaacCopyModel)

/*!
 This method creates a deep copy of any object. The object does not need to conform to NSCopying. It attempts to copy all of its properties to a new object. If the property does not adhere to NSCopying, then it recursively calls isc_deepCopyModel on the property.
 This is useful for copying models that you've created with isc_objectFromJsonWithClass:
 
 For NSDictionarys and NSArrays, it will create a deep copy.
 For structs and primitives, it simply copies the value.
 
 \discussion
 This class will not copy any properties which are not KVO compliant.
 It also will do a best effort to avoid infinite loops. It will not infinite loop on any classes that do not have a retain cycle.
 It does this by not copying any object properties which are declared as weak or assign.
 But, if your class has a retain cycle with two strong properties on objects that reference each other, then it will infinite loop. Since this is impossible if you derived your models from JSON, this is not a problem unless you're using this method for some other reason.
 */
- (instancetype)isc_deepCopyModel;

@end
