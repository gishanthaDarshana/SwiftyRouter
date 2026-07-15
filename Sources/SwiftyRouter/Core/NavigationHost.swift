import SwiftUI

/// Renders a root view and a stack of route-driven destination views.
///
/// `NavigationHost` observes a `NavigationRouter` and displays
/// each route in the router's stack as a destination layered above the root
/// view. The active destination sits at the leading edge while covered views
/// are shifted by the configured offsets.
public struct NavigationHost<Route: Equatable, Root: View, Destination: View>: View {
    @ObservedObject private var router: NavigationRouter<Route>
    private let rootOffset: CGFloat
    private let coveredOffset: CGFloat
    private let animation: Animation
    private let root: () -> Root
    private let destination: (Route) -> Destination

    /// Creates a  navigation host.
    ///
    /// - Parameters:
    ///   - router: The router that owns the navigation stack.
    ///   - rootOffset: The horizontal offset applied to the root while a destination is visible.
    ///   - coveredOffset: The horizontal offset applied to destinations covered by a newer destination.
    ///   - animation: The animation used when the router stack changes.
    ///   - root: A builder that creates the root view.
    ///   - destination: A builder that creates a destination view for each route.
    public init(
        router: NavigationRouter<Route>,
        rootOffset: CGFloat = -72,
        coveredOffset: CGFloat = -72,
        animation: Animation = .easeInOut(duration: 0.22),
        @ViewBuilder root: @escaping () -> Root,
        @ViewBuilder destination: @escaping (Route) -> Destination
    ) {
        self.router = router
        self.rootOffset = rootOffset
        self.coveredOffset = coveredOffset
        self.animation = animation
        self.root = root
        self.destination = destination
    }

    /// The composed navigation view hierarchy.
    public var body: some View {
        ZStack {
            root()
                .offset(x: router.stack.isEmpty ? 0 : rootOffset)

            ForEach(Array(router.stack.enumerated()), id: \.element.id) { index, session in
                destination(session.route)
                    .background(Self.defaultBackgroundColor)
                    .offset(x: index == router.stack.count - 1 ? 0 : coveredOffset)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))
                    .zIndex(Double(index + 1))
            }
        }
        .clipped()
        .animation(animation, value: router.stack)
    }

    private static var defaultBackgroundColor: Color {
        #if os(iOS)
        Color(.systemBackground)
        #elseif os(macOS)
        Color(NSColor.windowBackgroundColor)
        #else
        Color.clear
        #endif
    }
}
