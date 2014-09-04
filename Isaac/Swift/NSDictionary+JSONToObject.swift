//
//  NSDictionary+JSONToObject.swift
//  Isaac
//
//  Created by Peter Livesey on 9/3/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import Foundation

extension NSDictionary {
  
  func objectFromJSONWithClass<Model: NSObject>(aClass: Model.Type) -> Model {
    return self.isc_objectFromJSONWithClass(aClass) as Model
  }

}
