//  NavigationRouter.swift
//  SwiftyRouter
//  Created by GishanTha Darshana on 2026-07-15.

import Combine

/// Coordinates a  navigation stack for SwiftUI views.
///
/// `NavigationRouter` owns the ordered stack of routes rendered by
/// `NavigationHost`. Use the router to present, replace, or dismiss
/// routes without coupling feature views to the host implementation.
@MainActor
open class NavigationRouter<Route: Equatable>: ObservableObject {
    /// The currently presented navigation sessions, ordered from bottom to top.
    @Published public private(set) var stack: [NavigationSession<Route>] = []

    /// Creates an empty navigation router.
    public init() {}

    /// Presents a route by adding it to the top of the stack.
    ///
    /// This is an alias for `push(_:)`.
    /// - Parameter route: The route to present.
    open func present(_ route: Route) {
        push(route)
    }

    /// Adds a route to the top of the navigation stack.
    /// - Parameter route: The route to push.
    open func push(_ route: Route) {
        stack.append(NavigationSession(route: route))
    }

    /// Replaces the top route in the stack.
    ///
    /// If the stack is empty, the provided route is pushed as the first route.
    /// - Parameter route: The route that should become the top route.
    open func replaceTop(with route: Route) {
        guard !stack.isEmpty else {
            push(route)
            return
        }

        stack.removeLast()
        stack.append(NavigationSession(route: route))
    }

    /// Clears the current stack and presents a single route.
    /// - Parameter route: The only route that should remain in the stack.
    open func replaceAll(with route: Route) {
        stack = [NavigationSession(route: route)]
    }

    /// Removes the top route from the stack.
    ///
    /// Calling this method when the stack is empty has no effect.
    open func pop() {
        guard !stack.isEmpty else { return }
        stack.removeLast()
    }

    /// Removes all routes from the navigation stack.
    open func closeAll() {
        stack.removeAll()
    }
}
