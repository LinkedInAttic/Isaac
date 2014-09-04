//
//  SwiftSyntaxTests.swift
//  Isaac
//
//  Created by Peter Livesey on 9/3/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import Foundation
import XCTest

class SyntaxObject: NSObject {
  
}

class SwiftSyntaxTests: XCTestCase {

    func testObjectToJSON() {
      
      let json = NSDictionary()
      let model = json.objectFromJSONWithClass(SyntaxObject.self)
      XCTAssertTrue(model.isKindOfClass(SyntaxObject.self), "Should be the right class")
    }
}
