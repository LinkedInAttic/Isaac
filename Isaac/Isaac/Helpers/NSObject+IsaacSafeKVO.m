// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "NSObject+IsaacSafeKVO.h"

// Helpers
#import "ISCLog.h"

@implementation NSObject (IssacSafeKVO)

- (void)isc_safeSetValue:(id)value forKey:(id)key {
  // The try/catch doesn't seem great here for purity reasons.
  // It's needed because some properties are not KVO compliant, and will crash otherwise.
  // This shouldn't be a problem with any models anyone is passing in, but this code is written so it will never crash.
  // I would just check for respondsToSelector(@selector(set<key>:)) but that's not as general.
  // In terms of performance, I've tested this code with and without the try/catch, and it seems like this method is approximately
  // 1% slower with the try catch. This isn't worth worrying about, so I see no performance question here.
  @try {
    [self setValue:value forKey:key];
  }
  @catch (NSException *exception) {
    ISCLog(@"SafeKVC warning: Couldn't set value '%@' for key '%@'. Exception: %@", [value description], key, [exception description]);
  }
}

@end
