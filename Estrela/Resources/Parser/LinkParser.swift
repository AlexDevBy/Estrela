//
//  LinkParser.swift
//  Estrela
//
//  Created by Alex Misko on 08.01.23.
//

import Foundation
import SwiftyJSON

class LinkParser: IParser {
    typealias Model = String
    
    func parse(json: JSON) -> Model? {
        return json.arrayValue.first?["link"].stringValue
    }
}
