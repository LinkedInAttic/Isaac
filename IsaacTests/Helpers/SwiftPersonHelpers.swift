//
//  SwiftPersonHelpers.swift
//  Isaac
//
//  Created by Peter Livesey on 9/4/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import Foundation


class SwiftPerson: NSObject, Equatable, Printable {
  var name: NSString?
  var intAge: Int = 0
  var integerAge: NSInteger = 0
  var isCool: Bool = false
  var favoriteColors: NSArray = []
  var father: SwiftPerson?
  var siblings: NSArray?
  var metaData: NSArray?
  
  override var description: String {
    get {
      return "\(name) - \(intAge) - \(integerAge) - \(isCool) - \(favoriteColors) - \(father) - \(siblings) - \(metaData)"
    }
  }
  
  override func isc_classForObject(object: AnyObject!, inArrayWithKey key: String!) -> AnyClass! {
    if key == "siblings" {
      return SwiftPerson.self
    }
    if key == "metaData" {
      return NSDictionary.self
    }
    
    return super.isc_classForObject(object, inArrayWithKey: key)
  }
}

func ==(lhs: SwiftPerson, rhs: SwiftPerson) -> Bool {
  var fathersEqual = lhs.father == rhs.father
  
  // This is awkward, but I can't find a better way of doing this right now
  // Basically, for some reason == doesn't work here. Not sure why.
  var siblingsEqual = true
  if let ls = lhs.siblings {
    siblingsEqual = false
    if let rs = rhs.siblings {
      siblingsEqual = true
      for i in 0..<ls.count {
        siblingsEqual = siblingsEqual && rs[i] as SwiftPerson == ls[i] as SwiftPerson
      }
    }
  }
  
  var metaEqual = lhs.metaData == rhs.metaData
  
  return
    lhs.name! == rhs.name! &&
      lhs.intAge == rhs.intAge &&
      lhs.integerAge == rhs.integerAge &&
      lhs.isCool == rhs.isCool &&
      lhs.favoriteColors == rhs.favoriteColors &&
      fathersEqual &&
      siblingsEqual &&
      metaEqual
}

class PersonHelpers {
  
  class func personObject() -> SwiftPerson {
    let person = JSONPersonHelpers.personObject()
    
    let swiftPerson = SwiftPerson()
    swiftPerson.name = person.name
    swiftPerson.intAge = Int(person.intAge)
    swiftPerson.integerAge = person.integerAge
    swiftPerson.isCool = person.isCool
    swiftPerson.favoriteColors = person.favoriteColors as [NSString]
    println(person.metaData)
    swiftPerson.metaData = (person.metaData as [NSDictionary])
    
    swiftPerson.siblings = NSArray(object: siblingObject())
    swiftPerson.father = fatherObject()
    
    return swiftPerson
  }
  
  class func siblingObject() -> SwiftPerson {
    let person = JSONPersonHelpers.siblingObject()
    
    let swiftPerson = SwiftPerson()
    swiftPerson.name = person.name
    swiftPerson.intAge = Int(person.intAge)
    swiftPerson.integerAge = person.integerAge
    swiftPerson.isCool = person.isCool
    swiftPerson.favoriteColors = person.favoriteColors as [NSString]
    
    return swiftPerson
  }
  
  class func fatherObject() -> SwiftPerson {
    let person = JSONPersonHelpers.fatherObject()
    
    let swiftPerson = SwiftPerson()
    swiftPerson.name = person.name
    swiftPerson.intAge = Int(person.intAge)
    swiftPerson.integerAge = person.integerAge
    swiftPerson.isCool = person.isCool
    swiftPerson.favoriteColors = person.favoriteColors as [NSString]
    
    return swiftPerson
  }
  
}
