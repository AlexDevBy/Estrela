//
//  ConfigFactory.swift
//  Estrela
//
//  Created by Alex Misko on 08.01.23.
//

import Foundation

struct ConfigFactory {
    static func getCountries(ip: String?) -> ApiRequestConfig<CountryParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.countries(ip: ip), parser: CountryParser())
    }
    static func setPremium() -> ApiRequestConfig<SucceedParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.setPremium(days: nil), parser: SucceedParser())
    }
    static func loadLink() -> ApiRequestConfig<LinkParser> {
        return ApiRequestConfig(endPoint: NacionalJSONEndPoint.link, parser: LinkParser())
    }
    static func deleteProfile() -> ApiRequestConfig<DeleteParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.delete, parser: DeleteParser())
    }
    static func auth(code: String) -> ApiRequestConfig<AppleAuthParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.appleAuth(code), parser: AppleAuthParser())
    }
    static func auth(token: String) -> ApiRequestConfig<AuthParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.auth(token), parser: AuthParser())
    }
    static func savePushToken(token: String, country: String) -> ApiRequestConfig<SavePushTokenParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.updatePushToken(pushToken: token,
                                                                                countryCode: country),
                                parser: SavePushTokenParser())
    }
    static func revokeAppleToken(appleId: String) -> ApiRequestConfig<AppleRevokeTokenParser> {
        return ApiRequestConfig(endPoint: SortingBotApiEndPoint.revokeAppleToken(appleId: appleId),
                                parser: AppleRevokeTokenParser())
    }
}

