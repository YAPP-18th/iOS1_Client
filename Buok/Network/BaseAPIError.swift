//
//  BaseAPIError.swift
//  Nadam
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Alamofire
import Foundation
import HeroCommon
import HeroNetwork

public enum BaseAPIError: Error {
	case heroAPIError(HeroAPIError)
	case unknown
	
	public var errorMessage: String? {
		let message: String?
		switch self {
		case let.heroAPIError(error):
			let errorCode = error.errorCode
			if errorCode == .unauthorized || errorCode == .forbidden || errorCode == .notfound {
				message = "Error_Message_NetworkError"
			} else {
				message = "Network_ErrorMessage"
			}
		default:
			message = nil
		}
		return message
	}
	
	public init(error: Error?) {
		if let error = error as? HeroAPIError {
			self = .heroAPIError(error)
		} else {
            self = .heroAPIError(HeroAPIError(errorCode: .server, statusCode: -1004, errorMessage: error?.localizedDescription ?? "unknown"))
		}
	}
	
	public var isNetworkConnectionError: Bool {
		if case let .heroAPIError(brewAPIError) = self {
			let errorCode = brewAPIError.errorCode
			if errorCode == .unauthorized || errorCode == .forbidden || errorCode == .notfound {
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}
	
	public var statusCode: Int {
		switch self {
		case let .heroAPIError(heroAPIError):
			return heroAPIError.statusCode
		default:
			return 520 // unknown
		}
	}
}
