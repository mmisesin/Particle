//
//  APIError.swift
//  Particle
//
//  Created by Artem Misesin on 11/1/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

struct APIError: Error {
    var domain: String
    var code: Int
    var userInfo: [AnyHashable: Any]
    
    init(domain: String = "", code: Int = 0, userInfo dictionary: [AnyHashable: Any]) {
        self.domain = domain
        self.code = code
        self.userInfo = dictionary
    }
    
    init(errorDescription: String) {
        self.domain = ""
        self.code = 0
        self.userInfo = [NSLocalizedDescriptionKey: errorDescription]
    }
}

extension APIError {
    var errorDescription: String {
        if let errDesc = self.userInfo[NSLocalizedDescriptionKey] as? String {
            return errDesc
        }
        return Constants.unknownErrorDescription
    }
}

extension Error {
    var apiError: APIError {
        if let error = self as? APIError {
            return error
        } else {
            let castedError = self as NSError
            return APIError(domain: castedError.domain, code: castedError.code, userInfo: castedError.userInfo)
        }
    }
}
