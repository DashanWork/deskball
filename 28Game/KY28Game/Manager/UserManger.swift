//
//  UserManger.swift
//  KY28Game
//
//  Created by JACK on 2018/10/19.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit

class UserManger: NSObject, NSCoding {
    
    
    private(set) var name : String?
    private(set) var money : Int?
    private(set) var receiveTime : CLong? //上次领取金币的时间
    
    static let shareIntance = UserManger()
    
    //归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(money, forKey: "money")
        aCoder.encode(receiveTime, forKey: "receiveTime")
    }
    
    //解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        name = aDecoder.decodeObject(forKey: "name") as? String
        money = aDecoder.decodeObject(forKey: "money") as? Int
        receiveTime = aDecoder.decodeObject(forKey: "receiveTime") as? CLong
    }
    
    private override init() {
        super.init()
    }
    
    func firstLaunch(){
        self.name = "不打黑八"
        self.money = 2000
        self.receiveTime = CLong(NSDate().timeIntervalSince1970)
        CacheManager.shareIntance.saveUserManager(userManager: self)
        let window = UIApplication.shared.delegate?.window
        HubView.showTipOnView(tip: "首次登录送您2000金币", view: window as! UIView)
    }
    
    func launch(){
        let user = CacheManager.shareIntance.getUserManager()
        self.name = user.name
        self.money = user.money
        self.receiveTime = user.receiveTime
        let time = CLong(NSDate().timeIntervalSince1970)
        if time - (self.receiveTime ?? 0) > 18*60*60{
            self.receiveTime = time
            self.money = (self.money ?? 0) + 2000
            let window = UIApplication.shared.delegate?.window
            HubView.showTipOnView(tip: "送您2000金币", view: window as! UIView)
        }
    }
    
    func changeMoney(addMoney: Int){
        self.money = (self.money ?? 0) + addMoney
        CacheManager.shareIntance.saveUserManager(userManager: self)
    }
    

}
