//
//  Header.swift
//  swizzle
//
//  Created by Simon Zwicker on 14.02.22.
//

public enum Header {
    case Cookie
}

extension Header {
    var key: String {
        switch self {
        case .Cookie: return "Cookie"
        }
    }
    
    var value: String {
        switch self {
        default: return ""
        }
    }
}
