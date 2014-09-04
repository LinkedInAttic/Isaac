//
//  BasicSwiftTests.swift
//  Isaac
//
//  Created by Peter Livesey on 9/2/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import Foundation
import XCTest

class JSONParsingSwiftTests: XCTestCase {
  
  func testDataTypeMismatch() {
    
  }
  
  func testSimpleParsing() {
    let personJSON = JSONPersonHelpers.createTestPersonJSON()
    let expected = PersonHelpers.personObject()
    let actual = personJSON.objectFromJSONWithClass(SwiftPerson.self)
    
    println(actual)
    println(expected)
    
    XCTAssert(expected == actual, "Make sure the actual and expected match")
  }
}
