//
//  SwizzleService.swift
//  Swizzle
//
//  Created by Simon Zwicker on 14.02.22.
//

import Foundation
import Combine

class SwizzleService {
    
    // MARK: - Static Properties
    static let shared = SwizzleService()
    
    // MARK: - Properties [Private]
    private var baseUrl: URL?
    private var baseUrlString: String?
    private var timeout: TimeInterval?
    
    // MARK: - Set BaseUrl
    func configure(with url: String, timeout: TimeInterval? = nil) {
        self.baseUrlString = url
        self.baseUrl = URL(string: url)
        self.timeout = timeout
    }
    
    func configure(with component: SwizzleComponent, timeout: TimeInterval? = nil) {
        var urlComponent = URLComponents()
        urlComponent.scheme = component.scheme
        urlComponent.host = component.host
        urlComponent.path = component.path
        
        self.baseUrlString = urlComponent.string
        self.baseUrl = urlComponent.url
        self.timeout = timeout
    }
    
    func run<T: Codable>(_ point: SwizzlePoint) -> AnyPublisher<T, Error> {
        switch point.method {
        case .get: return get(point)
        default:
            return Fail(error: SwizzleError.BadRequest).eraseToAnyPublisher()
        }
    }
}

extension SwizzleService {
    private func get<T: Codable>(_ point: SwizzlePoint) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseUrlString ?? "")\(point.path)") else { return Fail(error: SwizzleError.BadRequest).eraseToAnyPublisher() }
        var request = URLRequest(url: url)
        request.httpMethod = point.method.rawValue
        point.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        Swizzle.swizzleLog.log(request)
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
