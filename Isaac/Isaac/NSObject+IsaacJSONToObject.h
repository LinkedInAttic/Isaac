// © 2014 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

/*!
 TL;DR: Call
 
    [jsonDictionary isc_objectFromJSONWithClass:]
 
 to get a foundation model object from a JSON dictionary.
 
 This is the main way to parse JSON directly into objects. Here's how you use it:
 With an NSDictionary representing JSON data, call [dictionary isc_objectFromJSONWithClass:] and give the class of the top-level object.
 
 Your foundation model should be a subclass of NSObject with the following:
 
 * All fields in the model are readwrite properties.
 * The JSON keys match the property names exactly (read below if you don't want a direct mapping)
 * The value types from JSON will match your model. For example, you have an int property, and the JSON value will be a number.
 * Objects with arrays must implement classForObject:inArrayWithKey:
 
 You can also override methods in NSObject (IsaacJSONToObjectModel) to customize model parsing.
 
 * Override isc_setJSONValue:forJSONKey: to totally take control of a key. Call super's version for keys you don't customize.
 * Override isc_keyForJSONKey: to change the mapping between JSON keys and property names. Call super for keys you don't customize.
 * Override isc_classForObject:inArrayWithKey: if you have an array of custom objects. If you have an array of NSString, NSDictionary or NSValue (including NSNumbers), you don't need this.
 * Override isc_classForObjectKey: to change the class mapping. For example, if you want to create a MyObject for an id property.
 
 Nested arrays are tricky, but possible. If you have a nested array with just JSON types (strings, values, dictionaries, arrays)
 then things will work fine. If you have a nested array with custom objects, you'll need to override isc_setJSONValue:forJSONKey:
 in the model object to handle the top-level array property.

 Limitations:
 
 * The top level JSON must be a dictionary, not an array or value type.
 * Your models cannot have nested arrays. classForObject:inArrayWithKey: must return a custom type or nil.
 * If you declare a property as a superclass of what you actually want it to be (like id instead of a custom class)
     you will need to override classForObjectKey:.
 */

@interface NSDictionary (IsaacJSONToObject)

/*!
 Constructs an instance of the given class, and populates it with data from the JSON dictionary (self).
 \param aClass Required. The type of object to create.
 \returns A new object of type aClass, filled with the JSON data from self.
 */
- (id)isc_objectFromJSONWithClass:(Class)aClass;

/*!
 Populates a model with data from the JSON dictionary (self).
 \param model (required) The object to populate.
 */
- (void)isc_populateJSONIntoModel:(NSObject *)model;

@end

/*!
 This category contains the main method you call on a JSON object (not a model object) to create the model object.
 */
@interface NSObject (IsaacJSONToObject)

/*!
 This method only applies when self is a dictionary.
 For non-dictionaries, this returns nil, as we don't know how to construct classes from any other JSON types.
 \param aClass Required. The type of object to create.
 */
- (id)isc_objectFromJSONWithClass:(Class)aClass;

@end


/*
 HELPER METHODS
 
 The methods below are helper methods which this class uses to parse the data.
 They are made public so you can override them in your own model classes if you want to.
 */


/*!
 This category contains methods you can override in the model object to customize parsing behavior. 
 You need to override \c isc_classForObject:inArrayWithKey: if you have custom objects in an array property.
 */
@interface NSObject (IsaacJSONToObjectModel)

/*!
 Set a key,value pair into the model object.
 \param jsonValue non-nil. The JSON object (\c NSDictionary, \c NSArray, \c NSNumber, \c NSDate or \c NSString) to set.
 \param jsonKey non-nil. The key from the JSON. It may or may not match the actual property name. ie. "first_name" vs "firstName"
 \discussion Override this method if you want total control over how to set properties. For any properties you do NOT want to 
     customize, call @code [super isc_setJSONValue:forJSONKey:] @endcode in your implementation.
 */
- (void)isc_setJSONValue:(id)jsonValue forJSONKey:(NSString *)jsonKey;

/*!
 Get the property name for a given JSON key. For example, first_name in JSON could map to a firstName property.
 By default, the JSON key is used as the property key. Override for custom behavior.
 \param jsonKey non-nil. The key from the JSON. ie. \c @"first_name"
 \discussion Override this method if you want to customize which JSON keys map to which properties, or if the names don't match
     exactly. For any keys you do NOT want to customize, call @code [super isc_keyForJSONKey:] @endcode in your implementation.
 */
- (NSString *)isc_keyForJSONKey:(NSString *)jsonKey;

/*!
 Get the class to instantiate for a property. The default is to use introspection to determine the property's type.
 By default, the JSON key is used as the property key. Override for custom behavior.
 \param objectKey non-nil. The property key (not the JSON key). ie. @"firstName"
 \discussion Override this method if you want to customize which class is instantiated for a property. For example, you 
 might want to return a subclass of the property's class.
 
 For any keys you do NOT want to customize, call @code [super classForObjectKey:] @endcode in your implementation.
 
 Note that you may return nil, which will cause \c setValue:forKey: to be called on the model without changing the JSON object.
 For example, if you have a NSString property you may just want to use the JSON object.
 */
- (Class)isc_classForObjectKey:(NSString *)objectKey;

/*!
 Get the class to instantiate for an array element. If this returns nil, the JSON object (string, dictionary, value)
 is put in the array. For custom objects in an array, return the class of the custom object.
 \param object non-nil. The JSON object (\c NSDictionary, \c NSArray, \c NSNumber, \c NSDate or \c NSString) in the array.
 \param key non-nil. The property key, not the JSON key. ie. \c @"firstName"
 \discussion Override this method if you want to customize the types of objects in the array. 
 If you return nil from this method, the same objects in the JSON array will be put into your array.
 */
- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key;

@end
