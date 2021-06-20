//
//  UserAPIRequest.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroNetwork
import Promise

// MARK: - Data
struct UserData: Codable {
	var id: Int
	var email: String
	var nickname: String
	var intro: String
	var profileUrl: String?
	var createdDate: String?
    var socialType: Int?
    var socialId: Int?
}

struct MyPageUserData: Codable {
	var user: UserData
	var friendCount: Int
	var bucketCount: Int
	var bookmark: BookmarkData
    
    func debugDescription() -> String {
        var message: String = ""
        message += "[UserData]\nEmail : \(user.email)\nNickname : \(user.nickname)\n"
        message += "Intro : \(user.intro)\nId : \(user.id)\nProfileURL : \(String(describing: user.profileUrl))\nCreatedDate : \(String(describing: user.createdDate))\n"
        message += "SocialType : \(String(describing: user.socialType))\nSocialId : \(String(describing: user.socialId))\n"

        message += "FriendCount : \(friendCount), BucketCount : \(bucketCount)\n"
        message += "[BookmarkData]\nBookmarkCount : \(bookmark.bookMarkCount)\n"
        if let list = bookmark.bookmarkList {
            for item in list {
                message += "BucketName : \(item.bucketName)\nId : \(item.id)\nEndDate : \(item.endDate)\nCategoryId : \(item.categoryId)\n"
            }
        }
        
        return message
    }
}

struct ProfileUserData: Codable {
    var user: UserData
    var friendCount: Int
    var bucketCount: Int
    var bookmark: BookmarkData
    var isFriend: Bool?
    var bucket: [BucketModel]
    
    func debugDescription() -> String {
        var message: String = ""
        message += "[UserData]\nEmail : \(user.email)\nNickname : \(user.nickname)\n"
        message += "Intro : \(user.intro)\nId : \(user.id)\nProfileURL : \(String(describing: user.profileUrl))\nCreatedDate : \(String(describing: user.createdDate))\n"
        message += "SocialType : \(String(describing: user.socialType))\nSocialId : \(String(describing: user.socialId))\n"

        message += "FriendCount : \(friendCount), BucketCount : \(bucketCount)\n"
        message += "isFriend : \(String(describing: isFriend))\n"
        message += "[BookmarkData]\nBookmarkCount : \(bookmark.bookMarkCount)\n"
        if let list = bookmark.bookmarkList {
            for item in list {
                message += "BucketName : \(item.bucketName)\nId : \(item.id)\nEndDate : \(item.endDate)\nCategoryId : \(item.categoryId)\n"
            }
        }
        
        message += "[BucketData]\nBucketCount : \(bucket.count)\n"
        for bucketItem in bucket {
            message += "BucketName : \(bucketItem.bucketName)\nId : \(bucketItem.id)\nEndDate : \(bucketItem.endDate)\nCategoryId : \(bucketItem.categoryId)\n"
        }
        
        return message
    }
}

struct BookmarkData: Codable {
	var bookmarkList: [BookmarkListData]?
	var bookMarkCount: Int
}

struct BookmarkListData: Codable {
	var id: Int
	var bucketName: String
	var endDate: String
	var categoryId: Int
}

struct ProfileData: Codable {
	var intro: String
	var nickname: String
	var profileUrl: String?
}

// MARK: - ServerModel
struct UserProfileServerModel: Codable {
	var status: Int
	var message: String
	var data: UserData
}

struct MyPageUserServerModel: Codable {
	var status: Int
	var message: String
	var data: MyPageUserData
}

struct ProfileUserServerModel: Codable {
    var status: Int
    var message: String
    var data: ProfileUserData
}

public struct UserAPIRequest {
	enum UserRequestType: APIRequestType {
		case getUserPage(userId: Int)
		case getProfile
		case getMyPageInfo
		case changeProfile(profile: [String: Any])
        case resetPassword(newPassword: String)
        case deleteUser
		
		var requestURL: URL {
			switch self {
            case let .getUserPage(userId):
                return URL(string: HeroConstants.user + "/\(userId)")!
			case .getProfile, .changeProfile:
				return URL(string: "/profile")!
			case .getMyPageInfo:
				return URL(string: HeroConstants.user + "/me")!
            case .resetPassword:
                return URL(string: HeroConstants.user + "/password")!
            case .deleteUser:
                return URL(string: HeroConstants.user)!
			}
		}
        
        var requestHeaders: [HeroHeader]? {
            switch self {
            case .resetPassword:
                return [.token(TokenManager.shared.getPasswordResetToken() ?? ""), .contentType]
            default:
                return [.token(TokenManager.shared.getAccessToken() ?? ""), .contentType]
            }
        }
        
        var imagesToUpload: [UIImage]? {
            nil
        }
        
		var requestParameter: [String: Any]? {
            switch self {
            case let .resetPassword(password):
                return ["password": password]
            default:
                return nil
            }
		}
		
		var httpMethod: HeroRequest.Method {
			switch self {
            case .getUserPage, .getProfile, .getMyPageInfo:
				return .get
            case .changeProfile, .resetPassword:
				return .put
            case .deleteUser:
                return .delete
			}
		}
		
		var encoding: HeroRequest.RequestEncoding {
			switch self {
            case .getUserPage, .deleteUser:
				return .url
            case .getProfile, .getMyPageInfo, .changeProfile, .resetPassword:
				return .json
			}
		}
		
		var requestBody: [String: Any]? {
			switch self {
            case .getUserPage, .getProfile, .getMyPageInfo, .resetPassword, .deleteUser:
				return nil
			case let .changeProfile(profile):
				return profile
			}
		}
	}
    
    static func deleteUser(responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: UserRequestType.deleteUser).then { responseData in
            do {
                if let dictData = responseData as? NSDictionary {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("responseData : \(dictData)")
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
	
    static func resetPassword(newPassword: String, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: UserRequestType.resetPassword(newPassword: newPassword)).then { responseData in
            do {
                if let dictData = responseData as? NSDictionary {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("responseData : \(dictData)")
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
	
    static func getUserInfo(responseHandler: @escaping (Result<UserData, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: UserRequestType.getProfile).then { responseData in
            do {
                if let dictData = responseData as? NSDictionary {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("responseData : \(dictData)")
                    DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
                    let getData = try JSONDecoder().decode(UserProfileServerModel.self, from: jsonData)
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
	
	static func getUserPageInfo(userId: Int, responseHandler: @escaping (Result<ProfileUserData, HeroAPIError>) -> Void) {
		BaseAPIRequest.requestJSONResponse(requestType: UserRequestType.getUserPage(userId: userId)).then { responseData in
			do {
				if let dictData = responseData as? NSDictionary {
					let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
					let getData = try JSONDecoder().decode(ProfileUserServerModel.self, from: jsonData)
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
	
	static func getMyPageIngo(responseHandler: @escaping (Result<MyPageUserData, HeroAPIError>) -> Void) {
		BaseAPIRequest.requestJSONResponse(requestType: UserRequestType.getMyPageInfo).then { responseData in
			do {
				if let dictData = responseData as? NSDictionary {
					let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("responseData : \(dictData)")
                    DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
                    
					let getData = try JSONDecoder().decode(MyPageUserServerModel.self, from: jsonData)
					let myPageUserData = getData.data
					if getData.status < 300 {
						responseHandler(.success(myPageUserData))
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
	
	static func changeProfileInfo(profile: ProfileData, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
		var profileArray = [String: Any]()
		profileArray["intro"] = profile.intro
		profileArray["nickname"] = profile.nickname
		profileArray["profileUrl"] = profile.profileUrl
		BaseAPIRequest.requestJSONResponse(requestType: UserRequestType.changeProfile(profile: profileArray)).then { responseData in
			do {
				if let dictData = responseData as? NSDictionary {
					let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
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
}
