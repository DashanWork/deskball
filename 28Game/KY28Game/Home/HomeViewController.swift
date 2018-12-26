//
//  HomeViewController.swift
//  KY28Game
//
//  Created by JACK on 2018/10/19.
//  Copyright © 2018年 sherily. All rights reserved.
//

import UIKit

let Game1Money : Int = 200
let Game2Money : Int = 500
let Game3Money : Int = 1000

class HomeViewController: UIViewController {
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moneyView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        UserManger.shareIntance.changeMoney(addMoney: 2000)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.text = "\(UserManger.shareIntance.name!)"
        self.moneyLabel.text = "\(UserManger.shareIntance.money!)"
    }
    
    
    
    //MARK: - click and action
    //第一个游戏按钮
    @IBAction func clickFirstGame(_ sender: Any) {
        self.enterGame(money: Game1Money)
    }
    
    //第二个游戏按钮
    @IBAction func clickSecondGame(_ sender: Any) {
        self.enterGame(money: Game2Money)
    }
    
    //第三个游戏按钮
    @IBAction func clickThirdGame(_ sender: Any) {
        self.enterGame(money: Game3Money)
    }
    
    func enterGame(money: Int){
        let userMoney = UserManger.shareIntance.money ?? 0
        if userMoney >= money{
            UserManger.shareIntance.changeMoney(addMoney: -money)
            let game = GameViewController.getGameVC()
            game.gameMoney = money
            self.navigationController?.pushViewController(game, animated: true)
        }else{
            HubView.showTip(tip: "抱歉，金币不足", vc: self)
        }
    }
    
    
    //设置
    @IBAction func clickSettings(_ sender: Any) {
        SettingsViewController.presentSettingVC(vc: self)
    }
    
    //客服
    @IBAction func clickFeedBack(_ sender: Any) {
        FeedBackViewController.presentFeedBackVC(vc: self)
    }
    
    //邮件
    @IBAction func clickEmail(_ sender: Any) {
        EmailViewController.presentEmailVC(vc: self)
    }
    
    //说明
    @IBAction func clickExplain(_ sender: Any) {
        ExplainViewController.presentExplainVC(vc: self)
    }
    
    //MARK: - 初始化
    func setupUI(){
        self.nameView.layer.cornerRadius = self.nameView.frame.size.height/2
        self.nameView.layer.borderWidth = 1
        self.nameView.layer.borderColor = UIColor.colorWithHex("90a8c2", alpha: 1)?.cgColor
        
        self.moneyView.layer.cornerRadius = self.nameView.frame.size.height/2
        self.moneyView.layer.borderWidth = 1
        self.moneyView.layer.borderColor = UIColor.colorWithHex("90a8c2", alpha: 1)?.cgColor
    }

}
