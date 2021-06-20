//
//  NotificationViewModel.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon

public class NotificationViewModel {
	var notificationCount: Dynamic<Int> = Dynamic(0)
	var notificationList: Dynamic<[NotificationModel]> = Dynamic([NotificationModel]())
	
	public init() {
		
	}
	
	func fetchNotificationList() {
		AlarmAPIRequest.alarmListRequest(responseHandler: { result in
			switch result {
			case .success(let listData):
				DebugLog("Fetch Notification List")
				self.notificationCount.value = listData.count
				self.notificationList.value = listData
			case .failure(let error):
				ErrorLog("fetchNotificationList ERROR : \(error.localizedDescription)")
			}
		})
	}
	
	func deleteNotificationLog(alarmId: Int, status: Int, indexPath: Int) {
		AlarmAPIRequest.deleteAlarmLog(alarmId: alarmId, status: status, responseHandler: { result in
			switch result {
			case .success(let isSuccess):
				DebugLog("Delete Notification Log Success : \(isSuccess)")
				self.fetchNotificationList()
			case .failure(let error):
				ErrorLog("ERROR: \(error.statusCode) / \(error.localizedDescription)")
			}
		})
	}
    
    func toMakeFriend(friendId: Int, alarmId: Int, accept: Bool) {
        FriendAPIRequest.makingFriend(friendId: friendId, alarmId: alarmId, accept: accept, responseHandler: { result in
            switch result {
            case .success(let isSuccess):
                DebugLog("To become Friend Success : \(isSuccess)")
            case .failure(let error):
                ErrorLog("ERROR: \(error.statusCode) / \(error.localizedDescription)")
            }
        })
    }
}
