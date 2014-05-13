FAQ
===

This library is recursive. Is there any worry of infinite loops?
----------------------------------------------------------------

In most use cases, no, you don't need to worry about it. But infinite loops can happen. The library will only infinite loop on objects which have a retain cycle. So, if you have an NSDictionary which contains a reference to itself, then attempting to parse this will infinite loop. Since this is impossible with JSON, you don't need to worry about anything you've parsed from JSON data. If you have an object with a delegate (which has a weak reference back to the parent object), then you can copy this without worrying about retain cycles. This is because the library ignore weak references and will not attempt to copy them.

My JSON contains nested arrays (an array with an array inside). Does this library support that?
-----------------------------------------------------------------------------------------------

Yes, but it's a little tricky. You'll need to override isc_setJSONValue:forJSONKey: and provide your own implementation. The implementation should basically create nested arrays of a similar format to your JSON, then call isc_objectFromJSONWithClass: on each object in your nested arrays, passing in the correct class. This is necessary to do, because it's really hard for the library to determine what class the objects in the array should have.

I don't want to use the same property names as my JSON. Some are even impossible (id). What can I do?
-----------------------------------------------------------------------------------------------------

Override isc_keyForJSONKey: in your model. For instance:

.. code-block:: objective-c

	- (NSString *)isc_keyForJSONKey:(NSString *)jsonKey {
	  if ([jsonKey isEqualToString:@"id"]) {
	    return @"objectId";
	  }
	  return [super isc_keyForJSONKey:jsonKey];
	}
	
Does this library support iOS 6?
--------------------------------

Yes. This library does support iOS 6. However, since XCTest is only supported in iOS 7, our unit tests do not cover iOS 6. Instead, we have validated with manual testing.
