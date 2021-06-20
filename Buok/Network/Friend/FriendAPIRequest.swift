//
//  FriendAPIRequest.swift
//  Buok
//
//  Created by 김보민 on 2021/06/16.
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroNetwork
import Promise

struct FriendUser: Codable {
    var userId: Int
    var email: String?
    var nickname: String?
    var intro: String?
    var profileUrl: String?
    var friendStatus: Int
}

struct FriendUserServerModel: Codable {
    var status: Int
    var message: String
    var data: [FriendUser]?
}

struct MakeFriendServerModel: Codable {
	var status: Int
	var message: String
	var data: Bool
}

public struct FriendAPIRequest {
    enum FriendRequestType: APIRequestType {
        case getFriendList(userId: Int)
        case makingFriend(friendId: Int, alarmId: Int, accept: Bool)
        case requestFriend(friendId: Int)
        
        var requestURL: URL {
            switch self {
            case let .getFriendList(userId):
                return URL(string: HeroConstants.user + "/\(userId)/friends")!
            case let .makingFriend(friendId, alarmId, _):
                return URL(string: HeroConstants.friend + "/\(friendId)/\(alarmId)")!
            case let .requestFriend(friendId):
                return URL(string: HeroConstants.friend + "/\(friendId)/request")!
            }
        }
        
        var requestHeaders: [HeroHeader]? {
			return [.token(TokenManager.shared.getAccessToken() ?? ""), .accept]
        }
        
        var imagesToUpload: [UIImage]? {
            nil
        }
        
        var requestParameter: [String: Any]? {
            switch self {
            case let .makingFriend(_, _, accept):
                return ["accept": accept]
            default:
                return nil
            }
        }
        
        var httpMethod: HeroRequest.Method {
            switch self {
            case .getFriendList:
                return .get
            default:
                return .post
            }
        }
        
        var encoding: HeroRequest.RequestEncoding {
            switch self {
            case .makingFriend:
                return .urlQuery
            default:
                return .url
            }
        }
        
        var requestBody: [String: Any]? {
            nil
        }
    }
    
    static func getFriendList(userId: Int, responseHandler: @escaping (Result<[FriendUser]?, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: FriendRequestType.getFriendList(userId: userId)).then { responseData in
            do {
                if let dictData = responseData as? NSDictionary {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
                    let getData = try JSONDecoder().decode(FriendUserServerModel.self, from: jsonData)
                    let userData = getData.data
                    if getData.status < 300 {
                        responseHandler(.success(userData))
                    } else {
                        responseHandler(.failure(HeroAPIError(errorCode: ErrorCode(rawValue: getData.status)!, statusCode: getData.status, errorMessage: getData.message)))
                    }
                }
            } catch {
                ErrorLog("ERROR Detected")
                responseHandler(.failure(HeroAPIError(errorCode: .unknown, statusCode: -1, errorMessage: "알 수 없는 오류")))
            }
        }
    }
    
    static func requestFriend(friendId: Int, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: FriendRequestType.requestFriend(friendId: friendId)).then { responseData in
            do {
                if let dictData = responseData as? NSDictionary {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
                    let getData = try JSONDecoder().decode(BaseServerModel.self, from: jsonData)
                    if getData.status < 300 {
                        responseHandler(.success(true))
                    } else {
                        responseHandler(.failure(HeroAPIError(errorCode: ErrorCode(rawValue: getData.status)!, statusCode: getData.status, errorMessage: getData.message)))
                    }
                }
            } catch {
                ErrorLog("ERROR Detected")
                responseHandler(.failure(HeroAPIError(errorCode: .unknown, statusCode: -1, errorMessage: "알 수 없는 오류")))
            }
        }
    }
    
    static func makingFriend(friendId: Int, alarmId: Int, accept: Bool, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: FriendRequestType.makingFriend(friendId: friendId, alarmId: alarmId, accept: accept)).then { responseData in
            do {
                if let dictData = responseData as? NSDictionary {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
                    let getData = try JSONDecoder().decode(MakeFriendServerModel.self, from: jsonData)
					let userData = getData.data
                    if getData.status < 300 {
                        responseHandler(.success(userData))
                    } else {
                        responseHandler(.failure(HeroAPIError(errorCode: ErrorCode(rawValue: getData.status)!, statusCode: getData.status, errorMessage: getData.message)))
                    }
                }
            } catch {
                ErrorLog("ERROR Detected")
                responseHandler(.failure(HeroAPIError(errorCode: .unknown, statusCode: -1, errorMessage: "알 수 없는 오류")))
            }
        }
    }
}
