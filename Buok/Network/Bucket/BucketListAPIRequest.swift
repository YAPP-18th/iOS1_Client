//
//  BucketListHomeAPIRequest.swift
//  Nadam
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroNetwork
import Promise

public struct BucketListAPIRequest {
	enum BucketRequestType: APIRequestType {
		case bucketsList(state: Int, category: Int, sort: Int)
		case bucketsPost(bucket: [String: Any])
		case bucketsEdit(bucketId: Int, bucket: [String: Any])
        case addBucketToBookmark(state: Bool, bucketId: Int)
        case setBucketPin(isPinned: Bool, bucketId: Int)
		case editBucketState(bucketId: Int, bucketStateId: Int)
		
		var requestURL: URL {
			switch self {
			case .bucketsList, .bucketsPost:
				return URL(string: HeroConstants.bucket)!
			case let .bucketsEdit(bucketId, _):
				return URL(string: HeroConstants.bucket + "/\(bucketId)")!
            case let .addBucketToBookmark(_, bucketId):
                return URL(string: HeroConstants.bucket + "/\(bucketId)/bookmark")!
            case let .setBucketPin(_, bucketId):
                return URL(string: HeroConstants.bucket + "/\(bucketId)/fin")!
			case let .editBucketState(bucketId, bucketStateId):
				return URL(string: HeroConstants.bucket + "/\(bucketId)/state/\(bucketStateId)")!
			}
		}
		
		var requestParameter: [String: Any]? {
			switch self {
			case let .bucketsList(state, category, sort):
				return ["state": state, "category": category, "sort": sort]
            case let.addBucketToBookmark(state, _):
                return ["state": state]
            case let.setBucketPin(isPinned, _):
                return ["state": isPinned]
			case let .editBucketState(bucketId, bucketStateId):
				return ["bucketId": bucketId, "bucketStateId": bucketStateId]
			case .bucketsPost, .bucketsEdit:
				return nil
			}
		}
		
		var httpMethod: HeroRequest.Method {
			switch self {
			case .bucketsList:
				return .get
			case .bucketsPost:
				return .post
			case .bucketsEdit, .addBucketToBookmark, .setBucketPin, .editBucketState:
				return .put
			}
		}
		
		var encoding: HeroRequest.RequestEncoding {
			switch self {
			case .bucketsList, .addBucketToBookmark, .setBucketPin, .editBucketState:
				return .urlQuery
			case .bucketsPost:
				return .json
			case .bucketsEdit:
				return .url
			}
		}
		
		var requestBody: [String: Any]? {
			switch self {
			case .bucketsList, .addBucketToBookmark, .setBucketPin, .editBucketState:
				return nil
			case let .bucketsPost(bucket), let .bucketsEdit(_, bucket):
				return bucket
			}
		}
        
        var imagesToUpload: [UIImage]? {
            nil
        }
	}
	
	static func editBucketState(bucketId: Int, bucketStateId: Int, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
		BaseAPIRequest.requestJSONResponse(requestType: BucketRequestType.editBucketState(bucketId: bucketId, bucketStateId: bucketStateId)).then { responseData in
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
				ErrorLog("BucketListAPIRequest ERROR")
			}
		}
	}
    
    static func setBucketPin(isPinned: Bool, bucketId: Int, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: BucketRequestType.setBucketPin(isPinned: isPinned, bucketId: bucketId)).then { responseData in
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
                ErrorLog("BucketListAPIRequest ERROR")
            }
        }
    }
    
    static func addBucketToBookmark(state: Bool, bucketId: Int, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
        BaseAPIRequest.requestJSONResponse(requestType: BucketRequestType.addBucketToBookmark(state: state, bucketId: bucketId)).then { responseData in
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
                ErrorLog("BucketListAPIRequest ERROR")
            }
        }
    }
	
	static func getBucketListData(state: Int, category: Int, sort: Int, responseHandler: @escaping (Result<BucketListData, HeroAPIError>) -> Void) {
		BaseAPIRequest.requestJSONResponse(requestType: BucketRequestType.bucketsList(state: state, category: category, sort: sort)).then { responseData in
			do {
				if let dictData = responseData as? NSDictionary {
					let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    DebugLog("responseData : \(dictData)")
                    DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
                    
					let getData = try JSONDecoder().decode(BucketListServerModel.self, from: jsonData)
					let bucketsData = getData.data
					if getData.status < 300 {
						responseHandler(.success(bucketsData))
					} else {
						responseHandler(.failure(HeroAPIError(errorCode: ErrorCode(rawValue: getData.status)!, statusCode: getData.status, errorMessage: getData.message)))
					}
				}
			} catch {
				ErrorLog("BucketListAPIRequest ERROR")
			}
		}
	}
	
	static func bucketPostRequest(bucket: BucketRequestModel, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
		var bucketArray = [String: Any]()
		bucketArray["bucketName"] = bucket.bucketName
		bucketArray["categoryId"] = bucket.categoryId
		bucketArray["content"] = bucket.content
		bucketArray["endDate"] = bucket.endDate
		bucketArray["imageList"] = bucket.imageList
		bucketArray["startDate"] = bucket.startDate
		bucketArray["bucketState"] = bucket.bucketState
		bucketArray["tagList"] = bucket.tagList
		BaseAPIRequest.requestJSONResponse(requestType: BucketRequestType.bucketsPost(bucket: bucketArray)).then { responseData in
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
				ErrorLog("BucketListAPIRequest ERROR")
			}
		}
	}
	
	static func editBucketInfo(bucketId: Int, bucket: BucketRequestModel, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
		var bucketArray = [String: Any]()
		bucketArray["bucketName"] = bucket.bucketName
		bucketArray["categoryId"] = bucket.categoryId
		bucketArray["content"] = bucket.content
		bucketArray["endDate"] = bucket.endDate
		bucketArray["imageList"] = bucket.imageList
		bucketArray["bucketState"] = bucket.bucketState
		bucketArray["tagList"] = bucket.tagList
		BaseAPIRequest.requestJSONResponse(requestType: BucketRequestType.bucketsEdit(bucketId: bucketId, bucket: bucketArray)).then { responseData in
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
				ErrorLog("BucketListAPIRequest ERROR")
			}
		}
	}
}
