JSON to Models
==============

Defined in NSObject+IsaacJSONToObject.h

Basic Example
-------------

Let's say you have some JSON which looks like this:

.. code-block:: objective-c
	
	JSON
	{
		"name":"Peter",
		"age": 32,
		"bestFriend": {
			"name": "Sudeep",
			"age": 27
		},
		"otherFriends": [
			{
				"name": "Mike",
				"age": 23
			}
		]
	}

If you want to convert this to a model, you would just write a model which looks like this:

.. code-block:: objective-c

	Person.h
	@interface
	@property (nonatomic, strong) NSString *name;
	@property (nonatomic, strong) NSInteger age;
	@property (nonatomic, strong) Person *bestFriend;
	@property (nonatomic, strong) NSArray *otherFriends;
	@end
	
	Person.m
	@implementation
	- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
  	  return [Person class];
	}
	@end

Normally, you don't need to include anything in the .m, but arrays are an exception. The library needs to know what sort of models are in the array, so you must implement this method.

Now, you just need to call:

.. code-block:: objective-c

	Person *model = [json isc_objectFromJSONWithClass:[Person class]];
	
And it will populate the model.

Other Methods
-------------

There are some other useful methods that you can override.

===========
Key Mapping
===========

This method is useful if the JSON has a key like "id". This is an illegal name for a property in Objective-C. You can map any JSON keys though if you don't want to have the same property names in your model.

.. code-block:: objective-c

	- (NSString *)isc_keyForJSONKey:(NSString *)jsonKey {
	  if ([jsonKey isEqualToString:@"id"]) {
	    // In our model, we have a property named personID
	    return @"personID";
	  }
	  return [super isc_keyForJSONKey:jsonKey];
	}
