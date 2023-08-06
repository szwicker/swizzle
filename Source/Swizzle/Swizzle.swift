//
//  Swizzle.swift
//  Swizzle
//
//  Created by Simon Zwicker on 14.02.22.
//

import Foundation
import Combine

public class Swizzle {
    
    // MARK: - Properties [Public]
    public var logLevel: LogLevel {
        get { return Swizzle.swizzleLog.logLevel }
        set { Swizzle.swizzleLog.logLevel = newValue }
    }
    
    // MARK: - Properties [Private]
    static let swizzleLog = SwizzleLog()
    
    // MARK: - Initialization
    public init(with baseUrl: String, timeout: TimeInterval? = nil) {
        SwizzleService.shared.configure(with: baseUrl, timeout: timeout)
    }
    
    public init(with component: SwizzleComponent, timeout: TimeInterval? = nil) {
        SwizzleService.shared.configure(with: component, timeout: timeout)
    }
    
    public func run<T: Codable>(_ point: SwizzlePoint) -> AnyPublisher<T, Error> {
        SwizzleService.shared.run(point)
    }
}
