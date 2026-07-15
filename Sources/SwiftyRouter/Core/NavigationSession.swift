import Foundation

/// A single entry in a  navigation stack.
///
/// Sessions wrap a route with a stable identifier so SwiftUI can distinguish
/// repeated presentations of equal routes in a `ForEach`.
public struct NavigationSession<Route: Equatable>: Identifiable, Equatable {
    /// A stable identifier for this stack entry.
    public let id: UUID

    /// The route represented by this stack entry.
    public let route: Route

    /// Creates a navigation session.
    ///
    /// - Parameters:
    ///   - id: A stable identifier for the session. Defaults to a new `UUID`.
    ///   - route: The route represented by the session.
    public init(id: UUID = UUID(), route: Route) {
        self.id = id
        self.route = route
    }
}
