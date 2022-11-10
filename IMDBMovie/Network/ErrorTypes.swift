//
//  ErrorTypes.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//

import Foundation
enum ErrorType: Error {
    case undefined
    case connection
    case request(Error?)
    case responseParse
    
    var message: String {
        switch self {
        case .undefined, .request, .responseParse: return "Something went wrong"
        case .connection: return "Seems you don't have internet connection"
        }
    }
}
