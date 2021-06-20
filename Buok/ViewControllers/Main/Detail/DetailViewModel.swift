//
//  DetailViewModel.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroNetwork

public class DetailViewModel {
    public var bucketDetailItem: Dynamic<BucketDetailModel?> = Dynamic(nil)
    public var bucketItem: Dynamic<BucketModel?> = Dynamic(nil)
    public var historyList: Dynamic<[BucketHistoryModel]?> = Dynamic(nil)
    public var tagList: Dynamic<[String]?> = Dynamic(nil)
    public var imageUrlList: Dynamic<[String]?> = Dynamic(nil)
    public var bucketContent: Dynamic<String> = Dynamic("")
    
    public var state: Dynamic<BucketState> = Dynamic(.now)
    public var isBookmark: Dynamic<Bool> = Dynamic(false)
    public var isPinned: Dynamic<Bool> = Dynamic(false)
    
    func setPinBucket() {
        if let itemId = bucketItem.value?.id {
            BucketListAPIRequest.setBucketPin(isPinned: !isPinned.value, bucketId: itemId, responseHandler: { [weak self] result in
                switch result {
                case .success(let isSuccess):
                    DebugLog("Set Pin Success : \(isSuccess)")
                    self?.isPinned.value = !(self?.isPinned.value ?? false)
                case .failure(let error):
                    ErrorLog("ERROR : \(error.statusCode) / \(error.localizedDescription)")
                }
            })
        }
    }
    
    func addBucketToBookmark() {
        if let itemId = bucketItem.value?.id {
            BucketListAPIRequest.addBucketToBookmark(state: !isBookmark.value, bucketId: itemId) { [weak self] result in
                switch result {
                case .success(let isSuccess):
                    DebugLog("Add Bookmark Success : \(isSuccess)")
                    self?.isBookmark.value = !(self?.isBookmark.value ?? false)
                case .failure(let error):
                    ErrorLog("ERROR : \(error.statusCode) / \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getBucketDetailInfo() {
        if let bucketId = bucketItem.value?.id {
            BucketAPIRequest.requestBucketDetail(bucketId: bucketId, responseHandler: { result in
                switch result {
                case .success(let bucketDetailModel):
                    DebugLog("Bucket Detail : \(bucketDetailModel.bucket.bucketName)")
                    self.bucketDetailItem.value = bucketDetailModel
                    self.bucketItem.value = bucketDetailModel.bucket
                    self.tagList.value = bucketDetailModel.tags?.map({ $0.tagName })
                    self.imageUrlList.value = bucketDetailModel.images?.map({ $0.imageUrl })
                    self.historyList.value = bucketDetailModel.bucketTimelines
                    self.isBookmark.value = bucketDetailModel.bucket.bookmark
                    self.isPinned.value = bucketDetailModel.bucket.fin
                    self.bucketContent.value = bucketDetailModel.bucket.content ?? ""
                case .failure(let error):
                    ErrorLog("ERROR: \(error.statusCode) / \(error.localizedDescription)")
                }
            })
        } else {
            ErrorLog("Bucket Id is nil.")
        }
    }
}
