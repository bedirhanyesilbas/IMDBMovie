//
//  Extensions.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//

import Foundation
import Alamofire
var isReachable: Bool {
    return (NetworkReachabilityManager()?.isReachable) ?? false
}
