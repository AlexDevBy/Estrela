//
//  PermissionsType.swift
//  Estrela
//
//  Created by codergirlTM on 09.01.23.
//

import Foundation

enum PermissionsType {
    case push(appWay: AppWayByCountry, link: String?)
    case location
    
    var title: String {
        switch self {
        case .push:
            return "Please, allow us to send you push-notifications for reminders."
        case .location:
            return "Please, allow us to track your location to find the most relevant sports facilities. "
        }
    }
}
