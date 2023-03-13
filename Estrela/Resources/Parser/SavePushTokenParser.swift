//
//  SavePushTokenParser.swift
//  Estrela
//
//  Created by Alex Misko on 10.01.23.
//

import Foundation
import SwiftyJSON

class SavePushTokenParser: IParser {
    typealias Model = Bool
    
    func parse(json: JSON) -> Model? {
        return true
    }
}
