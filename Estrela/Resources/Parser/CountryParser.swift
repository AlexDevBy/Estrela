//
//  CountryParser.swift
//  Estrela
//
//  Created by Alex Misko on 08.01.23.
//

import Foundation
import SwiftyJSON

class CountryParser: IParser {
    typealias Model = (LaunchModel)

    func parse(json: JSON) -> Model? {
        guard let tab = Int(json["data"]["tabs"].stringValue) else { return nil}
        return LaunchModel(countryCode: json["data"]["country_code"].stringValue,
                           appWay: AppWayByCountry(tab: tab))
    }
}
