Models to JSON
==============

Defined in NSObject+IsaacObjectToJson.h

Convert Models Back into JSON
-----------------------------

This can be used to convert model objects back into JSON. This can be useful when creating POST data from models. Simply call:

.. code-block:: objective-c
	- (id)isc_jsonRepresentation;

It is the inverse of:

.. code-block:: objective-c

	- (id)isc_objectFromJsonWithClass:(Class)aClass;
	
Debugging
---------

A very useful application of this is for debugging. You can recursively print out the properties of any object. For instance:

.. code-block:: objective-c

	(lldb) po model
	<FriendModel: 0xbe44530>
	
	(lldb) po [model isc_jsonRepresentation]
	{
	  values =     (
                {
            about = "Some text";
            age = 40;
            friends =             (
                                {
                    name = "Judith Stuart";
                },
                                {
                    name = "Lamb Gallegos";
                }
            );
	  }
	);
	}
	
This works on any object, not just objects you've created to use as models. However, if a property is not KVO-compliant, it will not put it in the JSON. This will never happen with classes you write, but means turning some UIKit objects into models does not work very well.
