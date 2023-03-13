//
//  ApiConstants.swift
//  Estrela
//
//  Created by Alex Misko on 08.01.23.
//

import Foundation

enum ApiConstants {
    
    enum URL {
        static let mainURL = "https://estrelabot.host"
        static let appleURL = "https://apps.apple.com/us/app/estrelabot/id1663757896"
        static let countryLink = "https://estrelabot.host/user/auth.json"
    }
    
    enum APIParameterKey {
        static let apiKey = "apiKey"
        static let id = "id"
        static let appleId = "apple_id"
        static let ident = "ident"
        static let name = "name"
        static let revoke = "revoke"
        static let pushToken = "device_id"
                
        // Прочие
        static let ip = "ip"
        static let token = "token"
        static let country = "country"
        
        // Apple params
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
    }
}
