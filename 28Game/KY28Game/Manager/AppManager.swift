//
//  AppManager.swift
//  KY28Game
//
//  Created by JACK on 2018/10/22.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    
    private var nameArry : Array = ["一杆清台","连进高手","斯诺克大师"];
    
    static let shareIntance = AppManager()
    private override init() {
        //
    }
    
    func isFirstLaunch()-> Bool{
        var first : Bool = true
        first = CacheManager.shareIntance.isFirstLauch()
        return first
    }
    
    func getrandomName()->String{
        let name : String?
        let num = Int(arc4random_uniform(UInt32(self.nameArry.count)))
        name = self.nameArry[num]
        return name!
    }
    

}
