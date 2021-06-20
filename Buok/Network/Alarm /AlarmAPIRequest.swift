//
//  AlarmAPIRequest.swift
//  Buok
//
//  Created by 김보민 on 2021/06/05.
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroNetwork
import HeroUI

public struct NotificationModel: Codable {
	var alarmId: Int
	var myUserId: Int?
	var friendId: Int?
	var title: String?
	var message: String
	var profileUrl: String?
	var friendStatus: Int
	var alarmStatus: Int
	var createdAt: String
}

struct AlarmLogServerModel: Codable {
	var status: Int
	var message: String
	var data: [NotificationModel]?
}

public struct AlarmAPIRequest {
	enum AlarmRequestType: APIRequestType {
		case getNotificationList
		case deleteNotification(alarmId: Int, status: Int)
		
		var requestURL: URL {
			switch self {
			case .getNotificationList:
				return URL(string: HeroConstants.alarm)!
			case let .deleteNotification(alarmId, _):
				return URL(string: HeroConstants.alarm + "/\(alarmId)")!
			}
		}
		
		var requestParameter: [String: Any]? {
			switch self {
			case .getNotificationList:
				return nil
			case let .deleteNotification(_, status):
				return ["alarm_status": status]
			}
		}
		
		var httpMethod: HeroRequest.Method {
			switch self {
			case .getNotificationList:
				return .get
			case .deleteNotification:
				return .delete
			}
		}
		
		var encoding: HeroRequest.RequestEncoding {
			switch self {
			case .getNotificationList:
				return .json
			case .deleteNotification:
				return .urlQuery
			}
		}
		
		var requestBody: [String: Any]? {
			nil
		}
		
		var imagesToUpload: [UIImage]? {
			nil
		}
	}
	
	static func alarmListRequest(responseHandler: @escaping (Result<[NotificationModel], HeroAPIError>) -> Void) {
		BaseAPIRequest.requestJSONResponse(requestType: AlarmRequestType.getNotificationList).then { responseData in
			do {
				if let dictData = responseData as? NSDictionary {
					let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
					DebugLog("Json Data : \n\(String(data: jsonData, encoding: .utf8) ?? "nil")")
					
					let getData = try JSONDecoder().decode(AlarmLogServerModel.self, from: jsonData)
					if getData.status < 300, let alarmData = getData.data {
						responseHandler(.success(alarmData))
					} else {
						responseHandler(.failure(HeroAPIError(errorCode: ErrorCode(rawValue: getData.status)!, statusCode: getData.status, errorMessage: getData.message)))
					}
				}
			} catch {
				ErrorLog("AlarmAPIRequest ERROR")
			}
		}
	}
	
	static func deleteAlarmLog(alarmId: Int, status: Int, responseHandler: @escaping (Result<Bool, HeroAPIError>) -> Void) {
		BaseAPIRequest.requestJSONResponse(requestType: AlarmRequestType.deleteNotification(alarmId: alarmId, status: status)).then { responseData in
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
				ErrorLog("AlarmAPIRequest ERROR")
			}
		}
	}
}
