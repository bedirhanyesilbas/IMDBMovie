//
//  Alert.swift
//  IMDBMovie
//
//  Created by Bedirhan Yeşilbaş on 9.11.2022.
//

import Foundation
import UIKit

struct AlertInfo {
    let title: String?
    let message: String?
    let actions: [AlertAction]
    
    init(title: String? = nil, message: String? = nil, actions: [AlertAction] = []) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

struct AlertAction {
    let onSelect: () -> Void
    let name: String
    let style: UIAlertAction.Style
}

extension UIAlertController {
    convenience init(info: AlertInfo, style: UIAlertController.Style = .alert) {
        self.init(title: info.title, message: info.message, preferredStyle: style)
        info.actions.forEach { actionInfo in
            let action = UIAlertAction(title: actionInfo.name, style: actionInfo.style, handler: { _ in
                actionInfo.onSelect()
            })
            self.addAction(action)
        }
    }
}
