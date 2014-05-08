.. Isaac documentation master file, created by
   sphinx-quickstart on Thu Apr 17 16:16:35 2014.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Isaac's documentation!
=====================================

.. toctree::
   :maxdepth: 1
   :glob:

   pages/*

Isaac is an open source project by LinkedIn. You can find the project on github: https://github.com/linkedin/Isaac/

TL;DR
-----

This library shoves data from JSON dictionaries into models. You write subclasses of NSObject with properties that match the JSON keys. Then call one method and the model will be populated with the JSON data. It is recursive and type-safe.

The Problem
-----------

It's easy to convert JSON into an NSDictionary. There are plenty of open source libraries that do it as well as Apple's provided NSJSONSerialization. But, when you start using this in code, things get ugly:

.. code-block:: objective-c

	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	NSString *firstPersonName = [[[[json objectForKey:@"peopleData"] objectForKey:@"values"] objectAtIndex:0] objectAtIndex:@"formatedName"];

This is problematic for a few reasons:

* It's not type safe. What if the object for key @"values" is actually a dictionary? Then we'll crash.
* It contains a bunch of hard coded strings (does formatted have one t or two?)
* It's ugly to read and write code this way.

So, usually, we represent JSON using models. This means the code above becomes:

.. code-block:: objective-c

	NSString *firstPersonName = model.peopleData.values[0].formattedName;

But then we have to write extra code for the models:

Friend.h

.. code-block:: objective-c

	@property (nonatomic, strong) NSString *name;
	@property (nonatomic, strong) Friend *friend;

Friend.m

.. code-block:: objective-c

	- (void)setupWithData:(NSDictionary *)data {
  	  // This is the worst! If only someone would make a library so I don't need to write this code...
	  if ([data[@"name"] isKindOfClass:[NSString class]]) {
	    self.name = data[@"name"];
	  }
	  if ([data[@"friend"] isKindOfClass:[NSDictionary class]]) {
	    self.friend = [[Friend alloc] init];
	    [self.friend setupWithData:data[@"friend"]];
	  }
	}
	
The problem here is obvious. Here, I have a model with just two properties, but I have to write 5 lines of code to inflate it? What happens when I work on a larger JSON object, this code is very boring to write and always the same.

Our Solution
------------

Let's take a look at parsing a BetterFriend model. We'll make the .h exactly the same as the Friend model from before. Using Isaac, to create a model from JSON:

.. code-block:: objective-c

	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	BetterFriend *model = [json isc_objectFromJsonWithClass:[BetterFriend class]];

That's easy, but that's not the best part. Let's take a look at the .m file for our BetterFriend class.

BetterFriend.m

.. code-block:: objective-c

	@implementation
	@end
	
Yep. No implementation is necessary. Isaac automatically takes JSON and populates your models. If the JSON has a key "name", it searches your model for a property called "name", checks that the types match, and if so, sets the property. It also works recursively. So if your JSON has nested dictionaries, you just need to declare a property with the type of another model, and Isaac will automatically populate it.

How It Works
------------

Isaac takes advantage of Objective-C's runtime capabilities. At runtime, it queries the types and names of the properties on the models and matches it to JSON keys.

What else can this magic library do?
------------------------------------

========================
Convert Models into JSON
========================

This is basically the opposite of converting JSON into a model. Isaac takes any object, and creates a JSON dictionary out of it. This can be useful when trying to send POST data to a server which you're creating from models and is also useful for debugging. You can print out all the properties of any object (including UIView, controllers, classes which don't implement description) recursively if you call:

.. code-block:: objective-c

	(lldb) po [model isc_jsonRepresentation]

===========
Copy Models
===========

You can copy any object (even if it doesn't conform to NSCopying). The implementation will create a new object of the same class, copy all of the properties of the old class and set it on the new class. It works recursively to create a deep copy.

.. code-block:: objective-c

	id copiedObject = [someObject isc_deepCopyModel];

