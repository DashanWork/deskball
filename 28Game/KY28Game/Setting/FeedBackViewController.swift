//
//  FeedBackViewController.swift
//  KY28Game
//
//  Created by JACK on 2018/10/19.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController {
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var contentText: UITextView!
    
    class func presentFeedBackVC(vc: UIViewController?){
        let controller = UIStoryboard.init(name: "HomeStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedBackID") as?  FeedBackViewController
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

        // Do any additional setup after loading the view.
    }

    //MARK: - click and action
    //关闭
    @IBAction func clickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //提交
    @IBAction func clickSubButton(_ sender: Any) {
        HubView.showTip(tip: "已收到反馈，稍后处理", vc: self)
        self.clickClose(UIButton())
    }
    
    
    
}
