//
//  HeroAPIError.swift
//  BucketList
//
//  Created by Taein Kim on 2021/03/03.
//

import Foundation

public enum ErrorCode: Int {
//        case cancelled = -9999
//        case badResponse = -1
//        case serverError = -2
//        case urlError = -3
//        case unauthorizedNetwork = -4
//        case notConnectedToInternet = -5
//        case cannotConnectToHost = -6
//        case timedOut = -7
    
	case exist = 400
    case unauthorized = 401
    case forbidden = 403
    case notfound = 404
	case unsupportedMediaType = 415
	case server = 500
}

public struct HeroAPIError: Error {
	public let statusCode: Int
	public let errorCode: ErrorCode
	public let errorMessage: String
	
	public init(errorCode: ErrorCode, statusCode: Int, errorMessage: String) {
		self.errorCode = errorCode
		self.statusCode = statusCode
		self.errorMessage = errorMessage
	}
}
