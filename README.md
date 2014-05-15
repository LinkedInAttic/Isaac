# Abstract

This library shoves data from JSON dictionaries into models. You write subclasses of NSObject with properties that match the JSON keys. Then call one method and the model will be populated with the JSON data. It is recursive and type-safe.

The best thing is, you don't need to write any code to populate these models. For most of your models, the .m will be empty. You just need to write a .h file which matches your JSON structure, and call one method:

```objective-c
BetterFriend *model = [json isc_objectFromJsonWithClass:[BetterFriend class]];
```

The library also has functionality to convert your models back into JSON and deeply copy models.

# Installation

## CocoaPods

Add to your Podfile:
pod Isaac

## Submodule

You can also add this repo as a submodule and copy everything in the Isaac folder into your project. You will also need to add -ObjC to your "Other Linker Flags" in your build settings.

# Documentation

## Microsite

For full documentation including code examples, how to use the library effectively and a full discussion on each capability, see our library documentation:

http://linkedin.github.io/Isaac/

## AppleDocs

For documentation on each method in the library and the parameters it takes, see our API documentation:

http://linkedin.github.io/Isaac/api-docs/
