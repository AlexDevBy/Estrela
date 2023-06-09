//
//  ApiConfiguration.swift
//  Estrela
//
//  Created by Alex Misko on 08.01.23.
//

import Foundation
import Alamofire

protocol ApiConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
}

enum SortingBotApiEndPoint: ApiConfiguration {
    case delete
    case auth(String)
    case appleAuth(String)
    case countries(ip: String?)
    case setPremium(days: String?)
    case revokeAppleToken(appleId: String)
    case updatePushToken(pushToken: String, countryCode: String)
    
    var method: HTTPMethod {
        switch self {
        case .countries, .setPremium, .revokeAppleToken, .delete:
            return .get
        case .updatePushToken, .auth, .appleAuth:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .appleAuth:
            return "/api/apauth/index.php"
        case .auth:
            return "/api/auth"
        case .delete:
            return "/api/profile/delete"
        case .countries:
            return "/api/getCountry"
        case .setPremium:
            return "/api/profile/premium"
        case .revokeAppleToken:
            return "/api/revokeToken"
        case .updatePushToken:
            return "/api/push/index.php"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .revokeAppleToken(let appleId):
            return [ApiConstants.APIParameterKey.token: appleId]
        case .auth(let token):
            return [ApiConstants.APIParameterKey.appleId: token]
        case .appleAuth(let code):
            return [ApiConstants.APIParameterKey.ident: code]
        case .countries(let ip):
            if let ip = ip {
                return [ApiConstants.APIParameterKey.ip: ip]
            }
            return nil
        case .updatePushToken(let pushToken, let countryCode):
            return [
                ApiConstants.APIParameterKey.token: pushToken,
                ApiConstants.APIParameterKey.country: countryCode
            ]
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .appleAuth, .updatePushToken:
            return [HTTPHeader.contentType("application/json; charset=UTF-8")]
        default:
            return HTTPHeaders(
                [:]
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlComp = NSURLComponents(string: ApiConstants.URL.mainURL.appending(path).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
        var items = [URLQueryItem]()
        // Параметры в урле
        
        switch self {
        case .auth, .countries, .revokeAppleToken:
            if let parameters = parameters {
                for (key, value) in parameters {
                    if let value = value as? String {
                        items.append(URLQueryItem(name: key, value: value))
                    }
                }
            }
        case .updatePushToken, .appleAuth:
            break
        default:
            if let token = SecureStorage.shared.getToken() {
                items.append(URLQueryItem(name: ApiConstants.APIParameterKey.token, value: token))
            }
        }
        if !items.isEmpty {
            urlComp.queryItems = items
        }
        var urlRequest = URLRequest(url: urlComp.url!)
        switch self {
        case .appleAuth, .updatePushToken, .auth:
            if let parameters = parameters {
                do {
                    let options = JSONSerialization.WritingOptions()
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: options)
                } catch {
                    
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
        default:
            break
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        return urlRequest
    }
}
