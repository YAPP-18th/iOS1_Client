//
//  InfoCheckAPIRequest.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroNetwork
import Promise

// MARK: - Data
struct NickName: Codable {
    var nickName: String
}

// MARK: - ServerModel
struct InfoCheckServerModel: Codable {
    var status: Int
    var message: String
    var data: String?
}

public struct InfoCheckAPIRequest {
    enum InfoCheckRequestType: APIRequestType {
        case emailCheck(email: String)
        case nicknameCheck(nickname: String)
        
        var requestURL: URL {
            switch self {
            case .emailCheck:
                return URL(string: HeroConstants.user + "/email-check")!
            case .nicknameCheck:
                return URL(string: HeroConstants.user + "/nickname-check")!
            }
        }
        
        var requestParameter: [String: Any]? {
            switch self {
            case let .emailCheck(email):
                return ["email": email]
            case let .nicknameCheck(nickname):
                return ["nickname": nickname]
            }
        }
        
        var httpMethod: HeroRequest.Method {
            .get
        }
        
        var encoding: HeroRequest.RequestEncoding {
            .urlQuery
        }
        
        var requestBody: [String: Any]? {
            nil
        }
        
        var imagesToUpload: [UIImage]? {
            nil
        }
    }
    
    static func checkEmail(email: String, responseHandler: @escaping (Result<Int, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: InfoCheckRequestType.emailCheck(email: email))
            .catch(type: BaseAPIError.self, { error in
                ErrorLog("ERROR가 발생하였습니다. ==> \(error)")
            })
            .then { responseData in
                do {
                    if let dictData = responseData as? NSDictionary {
                        let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                        DebugLog("responseData : \(dictData)")
                        DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
                        
                        let getData = try JSONDecoder().decode(InfoCheckServerModel.self, from: jsonData)
                        if getData.status < 300 || getData.status == 400 {
                            responseHandler(.success(getData.status))
                            DebugLog(getData.data ?? "")
                        } else {
                            responseHandler(.failure(HeroAPIError(errorCode: ErrorCode(rawValue: getData.status) ?? .unknown, statusCode: getData.status, errorMessage: getData.message)))
                        }
                    }
                } catch {
                    ErrorLog("InfoCheckAPIRequest ERROR")
                }
            }
    }
    
    static func checkNickname(nickname: String, responseHandler: @escaping (Result<Int, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: InfoCheckRequestType.nicknameCheck(nickname: nickname)).then { responseData in
            do {
                if let dictData = responseData as? NSDictionary {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("responseData : \(dictData)")
                    DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
                    
                    let getData = try JSONDecoder().decode(InfoCheckServerModel.self, from: jsonData)
                    if getData.status < 300 || getData.status == 400 {
                        responseHandler(.success(getData.status))
                        DebugLog(getData.data ?? "")
                    } else {
                        responseHandler(.failure(HeroAPIError(errorCode: ErrorCode(rawValue: getData.status) ?? .unknown, statusCode: getData.status, errorMessage: getData.message)))
                    }
                }
            } catch {
                ErrorLog("InfoCheckAPIRequest ERROR")
            }
        }
    }
}
