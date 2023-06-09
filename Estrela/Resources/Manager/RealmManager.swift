//
//  RealmManager.swift
//  Estrela
//
//  Created by Alex Misko on 28.12.22.
//

import Foundation
import RealmSwift

class RealmManager {
    
    
    static let shared = RealmManager()
    let realm = try! Realm()
    
    private init() {}
    
    func saveToRealm<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print("Error saving realm Object", error.localizedDescription)
        }
    }
    
    func deleteFromRealm<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting realm Object", error.localizedDescription)
        }
    }
}
