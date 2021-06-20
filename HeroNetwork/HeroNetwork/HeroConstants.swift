//
//  HeroConstants.swift
//  BucketList
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation

public struct HeroConstants {
//    public static let base = "http://13.125.236.11:8080/api/v2"
//    public static let base = "http://3.36.226.192:8080/api/v2"
//    public static let base = "http://yapp-load-balancer-539026644.ap-northeast-2.elb.amazonaws.com/api/v2"
    public static let base = "https://www.buok.ml/api/v2"
	
	public static var token: String {
		return "/token"
	}
	
	public static var user: String {
		return "/users"
	}
    
	public static var social: String {
		return "/social"
	}
	
    public static var email: String {
        return "/email"
    }
	
	public static var bucket: String {
		return "/buckets"
	}
    
    public static var search: String {
        return "/search"
    }
    
    public static var images: String {
        return "/images"
    }
	
	public static var alarm: String {
		return "/alarm"
	}
    
    public static var friend: String {
        return "/friend"
    }
}
