//
//  FriendPageViewModel.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import HeroCommon
import HeroUI
import Promise

struct FriendProfile {
    var type: FriendButtonType = .friend
    
    var buokmarks: [BuokmarkFlag] = [
        BuokmarkFlag(date: "2021.03", title: "나홀로 북유럽\n배낭여행 떠나기", category: "ic_fill_travel"),
        BuokmarkFlag(date: "2021.01", title: "취뽀 성공하기", category: "ic_fill_goal"),
        BuokmarkFlag(date: "2020.12", title: "패러글라이딩 도전", category: "ic_fill_hobby"),
        BuokmarkFlag(date: "2020.11", title: "교양학점 A이상 받기", category: "ic_fill_goal"),
        BuokmarkFlag(date: "2020.09", title: "친구들과 일본여행가서\n초밥 먹기", category: "ic_fill_travel"),
        BuokmarkFlag(date: "2020.08", title: "버킷리스트6", category: "ic_fill_want"),
        BuokmarkFlag(date: "2020.06", title: "버킷리스트7", category: "ic_fill_volunteer"),
        BuokmarkFlag(date: "2020.02", title: "버킷리스트8", category: "ic_fill_finance"),
        BuokmarkFlag(date: "2019.08", title: "버킷리스트9", category: "ic_fill_health"),
        BuokmarkFlag(date: "2019.05", title: "버킷리스트10", category: "ic_fill_etc")]
    
    var bucketBooks: [String] = ["나홀로 북유럽 배낭여행 떠나기", "취뽀 성공하기", "패러글라이딩 도전",
                                 "교양학점 A이상 받기", "친구들과 일본여행가서 초밥 먹기", "버킷리스트",
                                 "버킷리스트", "버킷리스트", "버킷리스트", "버킷리스트", "버킷리스트",
                                 "버킷리스트", "버킷리스트", "버킷리스트", "버킷리스트", "버킷리스트", "버킷리스트"]
}

class ProfileViewModel {
    private(set) var friendType: FriendButtonType = .friend
    private(set) var buokmarks: [BuokmarkFlag] = []
    private(set) var bucketBooks: [String] = []
    
    var userId: Int = 0
    var isMe: Dynamic<Bool> = Dynamic(false)
    
    var bucketBookData: Dynamic<[BucketModel]> = Dynamic([BucketModel]())
    var bucketBookCount: Dynamic<Int> = Dynamic(0)
    
    var bookmarkData: Dynamic<[BookmarkListData]> = Dynamic([BookmarkListData]())
    var bookmarkCount: Dynamic<Int> = Dynamic(0)
    
    var myUserData: Dynamic<MyPageUserData?> = Dynamic(nil)
    var userData: Dynamic<ProfileUserData?> = Dynamic(nil)
    
    func fetchProfileUserInfo() {
        UserAPIRequest.getUserPageInfo(userId: userId, responseHandler: { result in
            switch result {
            case .success(let userData):
                DebugLog(userData.debugDescription())
                self.userData.value = userData
                self.bucketBookCount.value = userData.bucketCount
                self.bucketBookData.value = userData.bucket
                self.bookmarkCount.value = userData.bookmark.bookMarkCount
                self.bookmarkData.value = userData.bookmark.bookmarkList ?? [BookmarkListData]()
            case.failure(let error):
                ErrorLog("API Error : \(error.statusCode) / \(error.errorMessage) / \(error.localizedDescription)")
            }
        })
    }
    
    func fetchMyPageInfo() {
        UserAPIRequest.getMyPageIngo(responseHandler: { result in
            switch result {
            case .success(let myPageUserData):
                DebugLog(myPageUserData.debugDescription())
                self.myUserData.value = myPageUserData
                self.bookmarkCount.value = myPageUserData.bookmark.bookMarkCount
                self.bookmarkData.value = myPageUserData.bookmark.bookmarkList ?? [BookmarkListData]()
				self.userId = myPageUserData.user.id
            case .failure(let error):
                ErrorLog("API Error : \(error.statusCode) / \(error.errorMessage) / \(error.localizedDescription)")
            }
        })
    }
}
