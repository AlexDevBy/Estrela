//
//  SucceedParser.swift
//  Estrela
//
//  Created by Alex Misko on 08.01.23.
//

import Foundation
import SwiftyJSON

class SucceedParser: IParser {
    
    typealias Model = (Bool, String)
    
    func parse(json: JSON) -> Model? {
        return (json["data"]["premium"].boolValue, json["message"].stringValue)
    }

}
