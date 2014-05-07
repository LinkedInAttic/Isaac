Thread Safety
=============

You can run all of these methods on any thread, but it doesn't mean that it is thread safe. In general, you can create models on a different thread if you are afraid of parsing speeds. For instance:

.. code-block:: objective-c

	// In the network stack on a different thread
	// No-one else is using this response yet because we haven't called back to any other thread
	NSDictionary *response;
	Person *model = [response isc_objectFromJSONWithClass:[Person class]];
	// Now call back to the main thread and pass back model
	
This code is fine since no-one else is using response or model since they haven't been passed to another thread yet.
