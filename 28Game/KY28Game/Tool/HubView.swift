//
//  HubView.swift
//  KY28Game
//
//  Created by JACK on 2018/10/30.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit
import MBProgressHUD

class HubView: NSObject {
    
    class func showTip(tip : String, vc : UIViewController){
        let hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
        hud.mode = .text
        hud.label.text = tip
        hud.isUserInteractionEnabled = false
        hud.hide(animated: true, afterDelay: 3)
    }
    
    class func showTipOnView(tip : String, view : UIView){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = tip
        hud.isUserInteractionEnabled = false
        hud.hide(animated: true, afterDelay: 3)
    }

}
