//
//  BucketModel.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation

// MARK: Bucket Detail 관련 모델들
public struct BucketHistoryModel: Codable {
    public var content: String
    public var modifiedDate: String
}

public struct TagModel: Codable {
    public var tagName: String
}

public struct ImageURLModel: Codable {
    public var imageUrl: String
}

// MARK: Bucket Detail 실제 사용하는 결과 모델
public struct BucketDetailModel: Codable {
    var bucket: BucketModel
    var images: [ImageURLModel]?
    var tags: [TagModel]?
    var bucketTimelines: [BucketHistoryModel]?
}

// MARK: Bucket Detail Server 결과 받아오는 모델
public struct BucketDetailServerModel: Codable {
    var status: Int
    var message: String
    var data: BucketDetailModel
}

// MARK: Bucket 기본 모델
public struct BucketModel: Codable {
    var id: Int
    var bucketName: String
    var createdDate: String
    var endDate: String
    var bucketState: Int
    var categoryId: Int
    var fin: Bool
    var bookmark: Bool
    var content: String?
}

public struct BucketListData: Codable {
    var buckets: [BucketModel]
    var bucketCount: Int
    
    func debugDescription() -> String {
        var message: String = ""
        message += "[BucketListData]\nBucketCount : \(bucketCount)"
        
        for item in buckets {
            message += "BucketName : \(item.bucketName)\nId : \(item.id)\nEndDate : \(item.endDate)\nCategoryId : \(item.categoryId)\n"
        }
        
        return message
    }
}

public struct BucketRequestModel: Codable {
    var bucketName: String
    var categoryId: Int
    var content: String
    var endDate: String
    var imageList: [String]?
    var startDate: String
    var bucketState: Int
    var tagList: [String]?
}

// MARK: - ServerModel
struct BucketListServerModel: Codable {
    var status: Int
    var message: String
    var data: BucketListData
}
