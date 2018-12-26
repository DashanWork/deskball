//
//  CacheManager.swift
//  KY28Game
//
//  Created by JACK on 2018/10/19.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit

class CacheManager: NSObject {
    
    static let shareIntance = CacheManager()
    
    private override init() {
        //
    }
    
    //MARK: - UserManager
    func saveUserManager(userManager: UserManger){
        if NSKeyedArchiver.archiveRootObject(userManager, toFile: self.userManagerPath()){
//            print("存储成功")
        }else{
//            print("没有存储成功")
        }
        
    }
    
    func getUserManager() -> UserManger{
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: self.userManagerPath()) as! UserManger
        return user
    }
    
    func userManagerPath() -> String{
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        paths = paths + "/user.txt"
        return paths
    }
    
    
    //MARK: - first launch
    func isFirstLauch() -> Bool{
        let ud = UserDefaults.standard
        let firstLauch : Bool = ud.bool(forKey: "Launched")
        if !firstLauch {
            //第一次
            ud.setValue(true, forKey: "Launched")
            ud.synchronize()
            return true
        }else{
            //不是第一次
            return false
        }
    }

}
