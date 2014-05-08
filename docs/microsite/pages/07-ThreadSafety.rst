Thread Safety
=============

You can run all of these methods on any thread, but it doesn't mean that it is thread safe. In general, you can create models on a different thread if you are afraid of parsing speeds.
	
If you do this, make sure that you don't edit the object after you've passed it to another thread. Your models are only as thread safe as you make them.

