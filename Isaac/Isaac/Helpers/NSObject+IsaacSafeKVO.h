// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>


@interface NSObject (IsaacSafeKVO)

/*!
 This is a wrapper around setValue:forKey: that will never crash.
 So it's behavior is exactly the same, except that if the class is not KVO compliant, setValue:forKey: will crash, while this will just do nothing.
 
 \discussion For more information, see the documentation for setValue:forKey:
 
 \param value The value for the property identified by key.
 \param key The name of one of the receiver's properties.
 */
- (void)isc_safeSetValue:(id)value forKey:(id)key;

@end
