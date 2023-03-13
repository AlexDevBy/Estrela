//
//  AppleRevokeTokenParser.swift
//  Estrela
//
//  Created by Alex Misko on 08.01.23.
//

import Foundation
import SwiftyJSON

class AppleRevokeTokenParser: IParser {
        
    typealias Model = Bool
    
    func parse(json: JSON) -> Model? {
        return true
    }
}
