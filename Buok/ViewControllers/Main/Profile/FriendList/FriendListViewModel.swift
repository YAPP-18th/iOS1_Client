//
//  FriendListViewModel.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import HeroCommon
import Promise

class FriendListViewModel {
    private var userId: Int
    var friendList: Dynamic<[FriendUser]?> = Dynamic(nil)
    
    public init(userId: Int) {
        self.userId = userId
    }
    
    func getFriendList() {
        FriendAPIRequest.getFriendList(userId: userId, responseHandler: { [weak self] result in
            switch result {
            case .success(let list):
                if let slist = list {
                    DebugLog("Friend List : \(slist)")
                    self?.friendList.value = slist
                } else {
                    DebugLog("Friend List is nil.")
                }
            case .failure(let error):
                ErrorLog(error.localizedDescription)
            }
        })
    }
}
