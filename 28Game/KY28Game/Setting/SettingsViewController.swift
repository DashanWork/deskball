//
//  SettingsViewController.swift
//  KY28Game
//
//  Created by JACK on 2018/10/19.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    class func presentSettingVC(vc: UIViewController?){
        let controller = UIStoryboard.init(name: "HomeStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingVCID") as?  SettingsViewController
        if controller != nil{
            controller?.modalPresentationStyle = .overFullScreen
            controller?.modalTransitionStyle = .crossDissolve
            vc?.present(controller!, animated: true, completion: {
//                controller?.view.superview?.backgroundColor = UIColor.clear
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - click and action
    
    
    //关闭
    @IBAction func clickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //音乐
    @IBAction func clickMusic(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
//        MusicManager.shareInstance.isBgMusic = btn.isSelected
    }
    //音效
    @IBAction func clickSound(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
//        MusicManager.shareInstance.isButtonMusic = btn.isSelected
    }
    
    
}
