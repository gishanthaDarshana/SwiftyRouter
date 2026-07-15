//
//  NavigationSessionTests.swift
//  SwiftyRouter
//
//  Created by Gishantha Darshana on 2026-07-15.
//
import Foundation
import Testing
@testable import SwiftyRouter

@Suite("NavigationSession")
struct NavigationSessionTests {
    @Test func initializesWithProvidedIdentifierAndRoute() {
        let id = UUID()

        let session = NavigationSession(id: id, route: TestRoute.details)

        #expect(session.id == id)
        #expect(session.route == .details)
    }

    @Test func sessionsAreEqualWhenIdentifierAndRouteMatch() {
        let id = UUID()

        let firstSession = NavigationSession(id: id, route: TestRoute.details)
        let secondSession = NavigationSession(id: id, route: TestRoute.details)

        #expect(firstSession == secondSession)
    }

    @Test func sessionsAreNotEqualWhenIdentifiersDiffer() {
        let firstSession = NavigationSession(route: TestRoute.details)
        let secondSession = NavigationSession(route: TestRoute.details)

        #expect(firstSession != secondSession)
    }
}
