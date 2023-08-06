//
//  SwizzlePoint.swift
//  swizzle
//
//  Created by Simon Zwicker on 14.02.22.
//

public protocol SwizzlePoint {
    var path: String { get }
    var method: Method { get }
    var headers: [Header] { get }
    var parameters: [String: String] { get }
    var encoding: Encoding { get }
}
