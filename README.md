# Unit Tests iOS Demo Project

This is a following up repo for my [iOS Unit Tests Guide](https://github.com/hayasilin/unit-tests-ios-guide).

It contains a real life demo project to simulate and show how to write unit tests in a iOS project and achieve higher code coverage.

- The project is developed in Xcode 11.
- This project is using MVVM pattern.(It didn't use coordinator)

## Code coverage result

The code coverage is **77.5%**

<img src="https://github.com/hayasilin/unit-tests-ios-demo-project/blob/master/resources/code_coverage_77.png">

## Higher code coverage

If I remove the code that are not used by the app, such as iOS system callback or core data code in AppDelegate.swift, the code coverage can be higher, up to **92.6**

<img src="https://github.com/hayasilin/unit-tests-ios-demo-project/blob/master/resources/code_coverage_92.png">