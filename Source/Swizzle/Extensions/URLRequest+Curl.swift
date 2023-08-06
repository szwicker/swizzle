//
//  URLRequest+Curl.swift
//  swizzle
//
//  Created by Simon Zwicker on 14.02.22.
//

import Foundation

extension URLRequest {
    public func curlCommand() -> String {
        guard let url = url else { return "" }
        var command = ["curl \"\(url.absoluteString)\""]
        
        if let method = httpMethod, method != Method.get.rawValue && method != Method.head.rawValue {
            command.append("-x \(method)")
        }
        
        allHTTPHeaderFields?
            .filter { $0.key != Header.Cookie.key }
            .forEach { command.append("-H '\($0.key): \($0.value)'") }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
}
