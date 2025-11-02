// Env.swift
// Wara
// Created by Meow on 02/11/25

import Foundation

enum Env {
    /// Detects when running inside SwiftUI Previews or UI tests.
    static var isPreview: Bool {
        let env = ProcessInfo.processInfo.environment
        if env["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return true }
        // Fallback: some preview hosts set this flag differently; also treat XCTest as preview-like.
        if env["SWIFTUI_PREVIEWS_ENVIRONMENT"] == "1" { return true }
        if NSClassFromString("XCTestCase") != nil { return true }
        return false
    }
}