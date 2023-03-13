//
//  Questions.swift
//  Estrela
//
//  Created by codergirlTM on 28.12.22.
//

import Foundation
import RealmSwift

class Questions: Object, Codable {
    
    @objc dynamic var id = ""
    @objc dynamic var question = ""
    @objc dynamic var date = Date()
    @objc dynamic var answerYes = ""
    @objc dynamic var answerNo = ""


    
    override class func primaryKey() -> String? {
        return "id"
    }
}

