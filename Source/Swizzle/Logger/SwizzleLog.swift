//
//  SwizzleLog.swift
//  swizzle
//
//  Created by Simon Zwicker on 14.02.22.
//

import Foundation

class SwizzleLog {
    var logLevel: LogLevel = .none
    
    func log(_ request: URLRequest) {
        guard logLevel != .none else { return }
        
        if let method = request.httpMethod, let url = request.url {
            print("Swizzle NetworkCall: \(method) - '\(url.absoluteString)'")
            logHeaders(request)
            logBody(request)
        }
        
        if logLevel == .debug {
            logCurl(request)
        }
    }
    
    func log(_ response: URLResponse, data: Data) {
        guard logLevel != .none else { return }
        
        if let response = response as? HTTPURLResponse {
            logStatusCodeUrl(response)
        }
        
        if logLevel == .debug {
            print("Swizzle Response DebugData: \(String(decoding: data, as: UTF8.self))")
        }
    }
    
    private func logHeaders(_ request: URLRequest) {
        guard let headerFields = request.allHTTPHeaderFields else { return }
        headerFields.forEach { print("Swizzle HttpHeader: \($0.key): \($0.value)") }
    }
    
    private func logBody(_ request: URLRequest) {
        guard let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) else { return }
        print("Swizzle HttpBody: \(bodyString)")
    }
    
    private func logStatusCodeUrl(_ response: HTTPURLResponse) {
        guard let url = response.url else { return }
        print("Swizzle StatusCode & Url: \(response.statusCode) - '\(url.absoluteString)'")
    }
    
    private func logCurl(_ request: URLRequest) {
        print("Swizzle CurlCommand: \(request.curlCommand())")
    }
}

