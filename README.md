[![Swift 5.10](https://img.shields.io/badge/swift-5.10-ED523F.svg?style=flat)](https://swift.org/download/)

# GitHub Repository Diff Tool

This application provides displaying pull request diffs for GitHub repositories. This is a project where I explore Swift artitectures, design patterns and frameworks.

> **_CALLOUT:_**  This project includes CoreData, but it does not support local storage/caching.  This application relies solely on network calls for data. CoreData implementations remains solely for reference until the implementation is converted to SwiftData.

> **_CALLOUT:_**  Dark Mode is not fully supported until the UIKit logic is converted to SwiftUI.

## Artitecture
### Clean
To maintain clean separation of concerns this project leverages a clean artitecture. This architecture divides the application into presentation, domain and data layers.

![clean artitecture](https://miro.medium.com/v2/resize:fit:300/format:webp/1*CmTYtsOw24RzTR_5Xw-L3A.png)[^CLEAN]

### MVVM
MVVM is used to separate business logic from the views themselves. Used with SwiftUI and UIKit views.

![mvvm](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/MVVMPattern.svg/300px-MVVMPattern.svg.png)[^MVVM]

### MVC
MVC is used to separate business logic, views and the domain. MVC is used in conjuction with MVVM to avoid "Massive View Controller"s. Only used with UIKit.

![mvc](https://miro.medium.com/v2/resize:fit:960/format:webp/1*VLOXe7bTN5m0n6wzxEIp3A.png)[^MVC]

## Design Patterns and Principles
- *Builder*: used for view composition
- *Coordinator*: extracts navigation logic to better ensure reusability of views as they are not coupled to screen transitions. [^Coordinator]
- *Delegate*: common delegation pattern used with UIKit views.
- *Dependency Injection*: dependencies are received from an external source and not created internally (allows for testing) [^DI]
- *Observer*: notifications to allow subjects to notify dependent objects (observers) about state changes.
- *Repository*:  layer between an applicatons domain logic and data storage.[^Repository]
- *Singleton*: although an anti-pattern singletons are used within many of Apple's frameworks in which there is a single shared instance.

## Frameworks
- CoreData
- Combine
- SwiftUI
- Swift Testing[^swift_testing], XCTest & XCUITest
- UIKit

### References and Inspiration
[^CLEAN]: [A Beginner’s Guide to Clean Architecture in SwiftUI: Building Better Apps Step by Step](https://medium.com/@walfandi/a-beginners-guide-to-clean-architecture-in-ios-building-better-apps-step-by-step-53e6ec8b3abd)
[^MVVM]: [Model–view–viewmodel](https://en.wikipedia.org/wiki/Model–view–viewmodel)
[^Repository]: [Repository design pattern in Swift explained using code examples](https://www.avanderlee.com/swift/repository-design-pattern/)
[^Coordinator]: [SwiftUI apps at scale](https://blog.jacobstechtavern.com/p/swiftui-apps-at-scale)
[^MVC]: [Understanding the Role of MVC in iOS Development: How Apple Utilizes the MVC Architecture in UI Libraries](https://medium.com/@viniciusnadin/understanding-the-role-of-mvc-in-ios-development-how-apple-utilizes-the-mvc-architecture-in-ui-4aa128ed59ad)
[^swift_testing]: [Partially generated with Testpiler](https://apps.apple.com/us/app/testpiler/id6737156289?mt=12)
[^DI]: [Dependency Injection in Swift Using Property Wrappers](https://www.cobeisfresh.com/blog/dependency-injection-in-swift-using-property-wrappers)
