# SwiftyRouter

SwiftyRouter is a lightweight route-driven navigation helper for SwiftUI. It gives you a generic `NavigationRouter` for managing a stack of routes and a `NavigationHost` for rendering those routes as layered destination views.

## Requirements

- Swift 6.2 or later
- iOS 15.0 or later
- macOS 10.15 or later

## Installation

### Swift Package Manager

In Xcode:

1. Open **File > Add Package Dependencies...**
2. Enter the package URL:

```text
https://github.com/gishanthaDarshana/SwiftyRouter.git
```

3. Add the `SwiftyRouter` product to your app target.

Or add it to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/gishanthaDarshana/SwiftyRouter.git", branch: "main")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["SwiftyRouter"]
    )
]
```

## Quick Start

Create an enum that represents the screens your flow can show. Routes only need to conform to `Equatable`.

```swift
import SwiftUI
import SwiftyRouter

enum AppRoute: Equatable {
    case profile(userID: String)
    case settings
    case confirmation(message: String)
}
```

Create and keep a router for the flow. In an app, this is usually owned by the root view, a coordinator view, or a view model.

```swift
struct ContentView: View {
    @StateObject private var router = NavigationRouter<AppRoute>()

    var body: some View {
        NavigationHost(router: router) {
            HomeView(router: router)
        } destination: { route in
            switch route {
            case .profile(let userID):
                ProfileView(userID: userID, router: router)

            case .settings:
                SettingsView(router: router)

            case .confirmation(let message):
                ConfirmationView(message: message, router: router)
            }
        }
    }
}
```

Navigate by calling the router from your views or view models.

```swift
struct HomeView: View {
    @ObservedObject var router: NavigationRouter<AppRoute>

    var body: some View {
        VStack {
            Button("Open Profile") {
                router.push(.profile(userID: "42"))
            }

            Button("Open Settings") {
                router.present(.settings)
            }
        }
    }
}
```

Dismiss or replace routes from destination views.

```swift
struct SettingsView: View {
    @ObservedObject var router: NavigationRouter<AppRoute>

    var body: some View {
        VStack {
            Button("Back") {
                router.pop()
            }

            Button("Show Confirmation") {
                router.replaceTop(with: .confirmation(message: "Saved"))
            }

            Button("Close Flow") {
                router.closeAll()
            }
        }
    }
}
```

## Navigation API

`NavigationRouter<Route>` owns the current stack:

```swift
@Published public private(set) var stack: [NavigationSession<Route>]
```

Use these methods to update the stack:

- `present(_:)`: Adds a route to the top of the stack. This is an alias for `push(_:)`.
- `push(_:)`: Adds a route to the top of the stack.
- `replaceTop(with:)`: Replaces the top route, or pushes the route when the stack is empty.
- `replaceAll(with:)`: Clears the current stack and leaves a single route.
- `pop()`: Removes the top route. Calling it on an empty stack does nothing.
- `closeAll()`: Removes every route from the stack.

Each stack entry is a `NavigationSession`. Sessions wrap a route with a stable `UUID`, so repeated presentations of the same route are still treated as separate SwiftUI entries.

## Custom Routers

`NavigationRouter` is an `open` class, so you can subclass it when a feature needs named navigation actions instead of exposing raw stack operations everywhere.

```swift
enum CheckoutRoute: Equatable {
    case cart
    case address
    case payment
    case confirmation(orderID: String)
}

final class CheckoutRouter: NavigationRouter<CheckoutRoute> {
    func startCheckout() {
        replaceAll(with: .cart)
    }

    func continueToAddress() {
        push(.address)
    }

    func continueToPayment() {
        replaceTop(with: .payment)
    }

    func complete(orderID: String) {
        replaceAll(with: .confirmation(orderID: orderID))
    }
}
```

The `stack` is publicly readable, so custom routers can inspect the current state before deciding which operation to apply. Stack mutation should still go through router methods such as `push(_:)`, `replaceTop(with:)`, `replaceAll(with:)`, `pop()`, and `closeAll()`.

## Customizing the Host

`NavigationHost` accepts optional layout and animation parameters:

```swift
NavigationHost(
    router: router,
    rootOffset: -72,
    coveredOffset: -72,
    animation: .easeInOut(duration: 0.22)
) {
    HomeView(router: router)
} destination: { route in
    destinationView(for: route)
}
```

- `rootOffset`: Horizontal offset applied to the root view while a destination is visible.
- `coveredOffset`: Horizontal offset applied to destination views covered by newer destinations.
- `animation`: Animation used when the router stack changes.

## Example Pattern

A practical setup is to keep the router at the feature boundary and pass actions down to smaller views:

```swift
final class AccountViewModel: ObservableObject {
    private let router: NavigationRouter<AppRoute>

    init(router: NavigationRouter<AppRoute>) {
        self.router = router
    }

    func didTapProfile() {
        router.push(.profile(userID: "42"))
    }

    func didFinish() {
        router.closeAll()
    }
}
```

This keeps navigation decisions in one place while still letting SwiftUI views stay simple.

## Running Tests

From the package root:

```sh
swift test
```

The test suite covers stack behavior such as pushing, replacing, popping, clearing, and repeated routes creating distinct sessions.


