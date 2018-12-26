//
//  ExplainViewController.swift
//  KY28Game
//
//  Created by JACK on 2018/10/19.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit

class ExplainViewController: UIViewController {
    
    class func presentExplainVC(vc: UIViewController?){
        let controller = UIStoryboard.init(name: "HomeStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExplainID") as?  ExplainViewController
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
    @IBAction func clickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    

}
