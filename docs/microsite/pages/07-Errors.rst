Error Handling
==============

You may notice that none of the methods in this library take an NSError pointer as a parameter. Any errors are handled gracefully, usually by just nilling out the offending value. For instance, if the server sends down a key which is not contained in the model, it will not throw an error, it will just not set the value. This is useful because often this can be expected behavior when taking into account backwards compatibility.

When writing code, you should not assume that any value is not nil, or that an array is filled unless you have confidence in the structure of the JSON you are passing in.

If you are developing, and cannot work out why a certain class is not being populated correctly, you can turn the library onto verbose mode where it will print out any errors it encounters. To turn on verbose mode add

ISAAC_VERBOSE=1

as a preprocessor macro for your project.
