Copying Models (or any object)
==============================

Defined in NSObject+IsaacCopyModel.h

Copy Model Objects
------------------

You can use this class to deeply copy model objects. In fact, you can use this class to deeply copy any object, even if it doesn't adhere to NSCopying. In copying, it will only copy property data.

Basic Algorithm
---------------

1. If the object is an array or dictionary, run our own deep copy code.
2. Else, if the object adhere's to NSCopying, call copy on the object.
3. Otherwise, create a new instance of the object (using [self class])
	a. For each property,
		i. If it's an object, call isc_deepCopyModel (for the recursion)
		ii. If it's an array or dictionary, make a deep copy or the array and call isc_deepCopyModel on each element of the array
		
In this way, it recursively goes through and eventually will end up calling copy on some primitives. So, it creates a deep copy, even though most things don't adhere to NSCopying. For NSArrays and NSDictionaries, we implement our own copy algorithm since calling copy returns a shallow copy by default.
	
Discussion
----------

Like the rest of this library, this method ignores properties which are not KVO compliant. So, using it to copy UIKit objects isn't advised (since a lot of UIKit is not KVO compliant).
