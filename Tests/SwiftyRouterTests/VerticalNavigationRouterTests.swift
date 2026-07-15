import Foundation
import Testing
@testable import SwiftyRouter

@Suite("NavigationRouter")
struct NavigationRouterTests {
    @Test func startsWithEmptyStack() {
        let router = NavigationRouter<TestRoute>()

        #expect(router.stack.isEmpty)
    }

    @Test func presentAddsRouteToStack() {
        let router = NavigationRouter<TestRoute>()

        router.present(.details)

        #expect(router.stack.map(\.route) == [.details])
    }

    @Test func pushAppendsRoutesInOrder() {
        let router = NavigationRouter<TestRoute>()

        router.push(.details)
        router.push(.settings)

        #expect(router.stack.map(\.route) == [.details, .settings])
    }

    @Test func pushingSameRouteCreatesDistinctSessions() throws {
        let router = NavigationRouter<TestRoute>()

        router.push(.details)
        router.push(.details)

        #expect(router.stack.map(\.route) == [.details, .details])
        #expect(try #require(router.stack.first).id != #require(router.stack.last).id)
    }

    @Test func replaceTopPushesRouteWhenStackIsEmpty() {
        let router = NavigationRouter<TestRoute>()

        router.replaceTop(with: .settings)

        #expect(router.stack.map(\.route) == [.settings])
    }

    @Test func replaceTopReplacesOnlyLastRoute() {
        let router = NavigationRouter<TestRoute>()

        router.push(.root)
        router.push(.details)
        router.replaceTop(with: .settings)

        #expect(router.stack.map(\.route) == [.root, .settings])
    }

    @Test func replaceAllClearsExistingStackAndKeepsSingleRoute() {
        let router = NavigationRouter<TestRoute>()

        router.push(.root)
        router.push(.details)
        router.replaceAll(with: .confirmation(id: "123"))

        #expect(router.stack.map(\.route) == [.confirmation(id: "123")])
    }

    @Test func popRemovesLastRoute() {
        let router = NavigationRouter<TestRoute>()

        router.push(.root)
        router.push(.details)
        router.pop()

        #expect(router.stack.map(\.route) == [.root])
    }

    @Test func popOnEmptyStackDoesNothing() {
        let router = NavigationRouter<TestRoute>()

        router.pop()

        #expect(router.stack.isEmpty)
    }

    @Test func closeAllClearsStack() {
        let router = NavigationRouter<TestRoute>()

        router.push(.root)
        router.push(.details)
        router.closeAll()

        #expect(router.stack.isEmpty)
    }
}
