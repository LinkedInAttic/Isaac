// © [2014] LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>


@interface NSObject (IsaacObjectToJSON)

/*!
 Convert this object to a JSON NSDictionary, using property interpolation. Effectively, this is the opposite of isc_objectFromJSONWithClass. So if you create a model from an NSDictionary, then call isc_jsonRepresentation on it, you get the original dictionary.
 
 \discussion Effectively, this recursively scans an object until it ultimately finds properties that are strings or numbers. It skips stucts and makes no attempt to decode them. It also skips objects that are weak references. This will help to avoid infinite cycles. However, if you have a retain cycle in the object you pass in, this code will infinite loop.
 This is also a useful debugging tool since you can effectively print out any object you're trying to debug when po doesn't yeild much.
 
 \note In Objective-C, BOOLs and chars are equivalent at runtime. Therefore, any property which is a char will be converted to a BOOL (NSNumber) by this method. Since chars can't really exist in JSON, we figure this is a good compromise.
 */
- (id)isc_jsonRepresentation;

@end
