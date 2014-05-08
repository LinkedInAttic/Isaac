Performance
===========

Discussion
-----------

We created a sample project to test the performance of this library. In general, we found that unless you are converting extremely large JSON into models (extremely large means over a MB), you do not need to worry about performance.

Production Code
---------------

At LinkedIn, we use this for all of our JSON parsing, and we've never seen it come up on any performance testing we've done. Basically, it's so fast compared to everything else in an app that you can ignore it. This takes into account the fact that for our app, we have some relatively large JSON responses. We do all of our parsing on the main thread for simplicity, but you can move it to a background thread if you want.

The Numbers
-----------

Let's get into the data. The time for this library to convert an NSDictionary into a model was about three times as slow as converting a JSON string into an NSDictionary. That means that this will increase the total time it takes for you to convert into models. But, this is three times as slow as something which is very fast.

Regular large object - 99KB
JSON Parsing - .00470 secoonds ::: Model Parsing - .0149 seconds

Extremely large object - 8.2MB (change your app code if you're doing something with JSON this big)
JSON Parsing - .567 secoonds ::: Model Parsing - 1.521 seconds

(Times are average of 20 attempts on an iPhone 5C)

Thread Safety
-------------

If you're doing large parsing or are worried, you can create models on a different thread. See the thread-safety section for more info.
