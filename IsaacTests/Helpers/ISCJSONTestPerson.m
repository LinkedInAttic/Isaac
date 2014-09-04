//
//  JSONPersonHelpers.m
//  Isaac
//
//  Created by Peter Livesey on 9/4/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

#import "ISCJSONTestPerson.h"
#import "NSObject+IsaacJSONToObject.h"


@implementation ISCJSONTestPerson

- (BOOL)isEqual:(id)object {
  ISCJSONTestPerson *other = (ISCJSONTestPerson *)object;
  
  BOOL nameEqual = [self.name isEqual:other.name];
  BOOL intAgeEqual = (self.intAge == other.intAge);
  BOOL integerAgeEqual = (self.integerAge == other.integerAge);
  BOOL isCoolEqual = (self.isCool == other.isCool);
  BOOL favesEqual = (self.favoriteColors == other.favoriteColors ||[self.favoriteColors isEqualToArray:other.favoriteColors]);
  BOOL sibsEqual = (self.siblings == other.siblings || [self.siblings isEqualToArray:other.siblings]);
  BOOL metaDataEqual = self.metaData == other.metaData || [self.metaData isEqual:other.metaData];
  
  return (nameEqual &&
          intAgeEqual &&
          integerAgeEqual &&
          isCoolEqual &&
          favesEqual &&
          sibsEqual &&
          metaDataEqual);
}

- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
  if ([key isEqualToString:@"siblings"]) {
    return [ISCJSONTestPerson class];
  }
  
  if ([key isEqualToString:@"metaData"]) {
    // We don't want to parse these. We just want to keep the NSDictionary as is.
    return [NSDictionary class];
  }
  
  return [super isc_classForObject:object inArrayWithKey:key];
}

@end
