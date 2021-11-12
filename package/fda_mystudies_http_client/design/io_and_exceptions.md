# Why did we select this particular IO pattern for each method?

We are using protocol-buffers for parsing the backend response, but the each method returns the `Object` instance.


## Why not use oneof here to differentiate between success and error objects?

The documentation provided in the interface provides all the details needed to parse the response. In almost all the cases we are returning a specific response or `CommonResponse` object for successful execution and `CommonErrorResponse` for any kind of failure. If we decided to go with one-of strategy for every single response we would be able to return concrete responses, but the implementation get messier since dart doesn't support mirroring (Currently the [dart:mirrors](https://api.dart.dev/stable/2.14.4/dart-mirrors/dart-mirrors-library.html) library is Unstable) yet -- We won't be able to assign a Class type to a instance dynamically at run-time. This hampers us from writing code that is both readable and reusable. So we stick with returning `Object` instance and provide good documentation to handle the instance properly.


## Why aren't we rethrowing exceptions?

Most of the api endpoints already return a `CommonErrorResponse` in case of server-side errors. We don't want to add an extra case to be handled for exception on every call on top of this. Decreasing this branching would improve the caller-side code as well by avoiding try-catch block on every call.


## Why not a wrap the request parameters in a single protocol-buffer message as well?

The generated code from protocol-buffers doesn't support `required` fields (all fields are treated as optional [link](https://developers.google.com/protocol-buffers/docs/reference/dart-generated#singular-message)). This would mean we would need to add validation logic in each call for required parameters if we used protocol buffers as input for each method. Dart provides a better way of differentiating between required and optional parameters in a function, which is what we are using to mandate parameters at caller's end. Beign null-safe, we don't allow setting null values for required parameters.
