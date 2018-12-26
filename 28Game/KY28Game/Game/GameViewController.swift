//
//  GameViewController.swift
//  KY28Game
//
//  Created by JACK on 2018/10/19.
//  Copyright © 2018年 sherily. All rights reserved.
//

//                 7
//            12
//        14       9
//    2       13
// 1       8       6
//    15       5
//         3      10
//             4
//                11
import UIKit

class GameViewController: UIViewController {
    var pen : CAKeyframeAnimation? = CAKeyframeAnimation.init()
    var animator : UIDynamicAnimator?
//    var push : UIPushBehavior?
    var collision : UICollisionBehavior?
    var itemBehavior : UIDynamicItemBehavior?
    var gameMoney : Int?
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var BaseView: UIView!
    @IBOutlet weak var GameView: UIView!
    @IBOutlet weak var energyImageView: UIImageView!
    var energyView : UIView?
    var energy : CGFloat? = 10
    
    
    //双方进球
    var isGoal : Bool? = false
    var manGoalArr : [BallView]? = Array.init()
    var machineGoalArr : [BallView]? = Array.init()
    //机器人
    var isMachineTrun : Bool? = false
    //球杆
    var cue : UIImageView?
    var oldAngle : CGFloat? = 0
    var isCanBegin : Bool? = true
    //白球
    var whiteBall : BallView?
    //1-15球
    var ball1 : BallView?
    var ball2 : BallView?
    var ball3 : BallView?
    var ball4 : BallView?
    var ball5 : BallView?
    var ball6 : BallView?
    var ball7 : BallView?
    var ball8 : BallView?
    var ball9 : BallView?
    var ball10 : BallView?
    var ball11 : BallView?
    var ball12 : BallView?
    var ball13 : BallView?
    var ball14 : BallView?
    var ball15 : BallView?
    var ballArray : [BallView]?
    
    
    class func getGameVC() -> GameViewController{
        let controller = UIStoryboard.init(name: "GameStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "GameID") as?  GameViewController
        return controller!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.animator = UIDynamicAnimator.init(referenceView: self.GameView)
        self.animator?.delegate = self
        self.nameLabel1.text = UserManger.shareIntance.name
        self.nameLabel2.text = AppManager.shareIntance.getrandomName()
        self.nameLabel1.sizeToFit()
        self.nameLabel2.sizeToFit()
        self.resetGame()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.BaseView.layer.cornerRadius = 15
        self.BaseView.clipsToBounds = true
        
    }
    
    
    
    //MARK: - click and action
    @IBAction func clickClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = ((touches as NSSet).anyObject() as AnyObject)
        
//        let point = touch.location(in: self.GameView)
        
//        self.pushWhiteBall()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as! UITouch)
        
        let point = touch.location(in: self.GameView)
        if (touch.view?.isEqual(self.GameView))!{
            self.moveCuePoint(point: point)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = ((touches as NSSet).anyObject() as AnyObject)
        
//        let point = touch.location(in: self.GameView)
        
//        self.moveCuePoint(point: point)
    }
    
    @objc func clickEnergy(tap : UITapGestureRecognizer){
        let point = tap.location(in: self.energyImageView)
        let x = self.energyImageView.frame.origin.x
        let y = self.energyImageView.frame.origin.y
        let width = self.energyImageView.frame.size.width
        let height = self.energyImageView.frame.size.height
        self.energyView?.frame = CGRect.init(x: x, y: y + point.y, width: width, height: height - point.y)
//        self.energyView?.colorChange(color1: UIColor.red, color2: UIColor.yellow)
        self.energy = (self.energyView?.frame.size.height)!/height * 10
        HubView.showTip(tip: "力量\(String(format: "%.1f", self.energy!))", vc: self)
        
    }
    
    @IBAction func hitBall(_ sender: Any) {
        self.pushWhiteBall()
    }
    
    
    //MARK: - 游戏算法
    
    //顺时针或者逆时针
    func circleAngle(angle: CGFloat, point: CGPoint, center: CGPoint) -> Bool{
        let a = point.x - center.x
        let b = point.y - center.y
        let c = CGFloat(-170)
        let d = CGFloat(0)
        var reds1 = angle
        if reds1 < 0{
            reds1 = CGFloat.pi*2 + angle
        }
        var reds2 = acos((a * c + b * d) / (sqrt(a * a + b * b) * sqrt(c * c + d * d)))
        if (b > 0) {
            reds2 = -reds2 + CGFloat.pi*2
        }
        
        if (reds2 - reds1) > CGFloat.pi{
            return false
        }
        
        if (reds2 - reds1) > -CGFloat.pi && (reds2 - reds1) < 0{
            return false
        }
        
        return true
     
    }
    
    //球杆转动
    func moveCuePoint(point : CGPoint) {
        if !(self.isCanBegin!) || self.isMachineTrun! {
            return
        }
        if self.cue == nil{
            self.cue = UIImageView.init(image: UIImage.init(named: "qiuganquan"))
            self.cue?.frame = CGRect.init(x: 0, y: 0, width: 305.5, height: 15.5)
            self.cue?.center = CGPoint.init(x: (self.whiteBall?.center.x)! - 170 + self.BaseView.frame.origin.x + self.GameView.frame.origin.x, y: (self.whiteBall?.center.y)! + self.BaseView.frame.origin.y + self.GameView.frame.origin.y)
            self.view.addSubview(self.cue!)
        }else{
            self.cue?.center = CGPoint.init(x: (self.whiteBall?.center.x)! - 170 + self.BaseView.frame.origin.x + self.GameView.frame.origin.x, y: (self.whiteBall?.center.y)! + self.BaseView.frame.origin.y + self.GameView.frame.origin.y)
        }
        self.cue?.isHidden = false
        let a : CGFloat = point.x - (self.whiteBall?.center.x)!
        let b : CGFloat = point.y - (self.whiteBall?.center.y)!
        let c : CGFloat = -170
        let d : CGFloat = 0
        
        var reds = acos((a * c + b * d) / (sqrt(a * a + b * b) * sqrt(c * c + d * d)))
        if (b > 0) {
            reds = -reds + CGFloat.pi*2
        }
        let oldAngle = reds
        
        var angle = self.oldAngle
        
        if self.circleAngle(angle: self.oldAngle!, point: point, center: (self.whiteBall?.center)!){
            reds = reds - angle!
            if reds < 0{
                reds = reds + CGFloat.pi*2
            }
        }else{
            if angle! < 0{
                angle = 0 - angle!
            }
            
            reds = -(angle! - reds + CGFloat.pi*2)
            if reds > 0{
                reds = reds - CGFloat.pi*2
            }
            if reds < -CGFloat.pi*2{
                reds = reds + CGFloat.pi*2
            }
        }
        
        self.pen?.keyPath = "position"
        let pathRef = CGMutablePath.init()
        if reds < 0{
            self.cue?.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi/2)
        }else{
            self.cue?.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2)
        }
        pathRef.addRelativeArc(center: CGPoint.init(x: 170, y: 0), radius: 170, startAngle: (self.oldAngle ?? 0) + CGFloat.pi, delta: reds)
        self.pen?.path = pathRef
        self.pen?.duration = 1
        self.pen?.isAdditive = true
        self.pen?.repeatCount = 0
        self.pen?.calculationMode = kCAAnimationPaced
        self.pen?.rotationMode = kCAAnimationRotateAuto
        self.pen?.isRemovedOnCompletion = false
        self.pen?.fillMode = kCAFillModeForwards
        self.cue?.layer.add(self.pen!, forKey: "oribit")
        self.oldAngle = oldAngle
    }

    //撞白球
    func pushWhiteBall(){
        if !(self.isCanBegin!) {
            return
        }
        let push = UIPushBehavior.init(items: [self.whiteBall!], mode: .instantaneous)
        push.angle = self.oldAngle!
        push.magnitude = self.energy!
        self.animator?.addBehavior(push)
        var collisionItem = [self.whiteBall]
        for ball in self.ballArray! {
            collisionItem.append(ball)
        }

        if self.itemBehavior == nil{
            self.itemBehavior = UIDynamicItemBehavior.init(items: collisionItem as! [UIDynamicItem])
        
            //阻力
            self.itemBehavior?.resistance = 1
            //旋转阻力
            self.itemBehavior?.angularResistance = 1
            //质量密度
            self.itemBehavior?.density = 10
            self.animator?.addBehavior(self.itemBehavior!)
        }
        
        let bgx = CGFloat(0)//self.BaseView.frame.origin.x + self.GameView.frame.origin.x
        let bgy = CGFloat(0)//self.BaseView.frame.origin.y + self.GameView.frame.origin.y
        let bgWidth = self.GameView.frame.size.width
        let bgHeight = self.GameView.frame.size.height
        
        //弹力
        if self.collision == nil{
            self.collision = UICollisionBehavior.init(items: collisionItem as! [UIDynamicItem])
            self.collision?.collisionDelegate = self
        
//        let collision = UICollisionBehavior.init(items: collisionItem as! [UIDynamicItem])
            self.collision?.addBoundary(withIdentifier: "left" as NSCopying, from: CGPoint.init(x: bgx, y: bgy), to: CGPoint.init(x: bgx, y: bgy + bgHeight))
            self.collision?.addBoundary(withIdentifier: "top" as NSCopying, from: CGPoint.init(x: bgx, y: bgy), to: CGPoint.init(x: bgx + bgWidth, y: bgy))
            self.collision?.addBoundary(withIdentifier: "right" as NSCopying, from: CGPoint.init(x: bgx + bgWidth, y: bgy), to: CGPoint.init(x: bgx + bgWidth, y: bgy + bgHeight))
            self.collision?.addBoundary(withIdentifier: "bottom" as NSCopying, from: CGPoint.init(x: bgx, y: bgy + bgHeight), to: CGPoint.init(x: bgx + bgWidth, y: bgy + bgHeight))
            self.collision?.collisionDelegate = self
            self.animator?.addBehavior(self.collision!)
        }
        self.isCanBegin = false
        self.isGoal = false
        self.cue?.isHidden = true
        
    }
    //MARK: - 机器轮次
    func machineHit(){
        if self.isMachineTrun!{
            HubView.showTip(tip: "对手回合", vc: self)
//            print("机器轮次")
//            let angle = self.machineAngle()
//            print("角度\(angle)")
            self.machineMoveCue(angle: self.machineAngle())
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let push = UIPushBehavior.init(items: [self.whiteBall!], mode: .instantaneous)
                push.angle = self.machineAngle()
                push.magnitude = 10
                self.animator?.addBehavior(push)
                self.isGoal = false
                self.cue?.isHidden = true
            }

            
        }else{
            HubView.showTip(tip: "您的回合", vc: self)
            self.cue?.center = CGPoint.init(x: (self.whiteBall?.center.x)! - 170 + self.BaseView.frame.origin.x + self.GameView.frame.origin.x, y: (self.whiteBall?.center.y)! + self.BaseView.frame.origin.y + self.GameView.frame.origin.y)
            
            self.cue?.isHidden = false
        }
    }
    
    func machineMoveCue(angle : CGFloat){
//        var red = (angle + CGFloat.pi)
//        red = fmod(red, CGFloat.pi*2)
        self.cue?.center = CGPoint.init(x: (self.whiteBall?.center.x)! - 170 + self.BaseView.frame.origin.x + self.GameView.frame.origin.x, y: (self.whiteBall?.center.y)! + self.BaseView.frame.origin.y + self.GameView.frame.origin.y)
        
        self.cue?.isHidden = false
        
        self.pen?.keyPath = "position"
        let pathRef = CGMutablePath.init()
        if angle < 0{
            self.cue?.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi/2)
        }else{
            self.cue?.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2)
        }
        pathRef.addRelativeArc(center: CGPoint.init(x: 170, y: 0), radius: 170, startAngle: CGFloat.pi, delta: angle)
        self.pen?.path = pathRef
        self.pen?.duration = 1
        self.pen?.isAdditive = true
        self.pen?.repeatCount = 0
        self.pen?.calculationMode = kCAAnimationPaced
        self.pen?.rotationMode = kCAAnimationRotateAuto
        self.pen?.isRemovedOnCompletion = false
        self.pen?.fillMode = kCAFillModeForwards
        self.cue?.layer.add(self.pen!, forKey: "oribit")
    }
    
    func machineAngle()-> CGFloat{
        var angle : CGFloat = 0
        var hitBall : BallView = BallView()
        var a : CGFloat = 0
        var b : CGFloat = 0
        var c : CGFloat = 0
        var d : CGFloat = 0
        
        //选择击打的球号
        if (self.machineGoalArr?.count)! > 0 && (self.machineGoalArr?.count)! < 7{
            let goalBall = self.machineGoalArr![0]
            let machineTurn =  self.judgeBall(ball: goalBall)
            if machineTurn > 0{
                for ball in self.ballArray!{
                    if self.judgeBall(ball: ball) > 0{
                        hitBall = ball
                        break
                    }
                }
            }else if machineTurn < 0{
                for ball in self.ballArray!{
                    if self.judgeBall(ball: ball) < 0{
                        hitBall = ball
                        break
                    }
                }
            }else{
                hitBall = self.ball8!
            }
            
        }else if (self.manGoalArr?.count)! > 0{
            let goalBall = self.manGoalArr![0]
            let manTurn = self.judgeBall(ball: goalBall)
            if manTurn > 0{
                for ball in self.ballArray!{
                    if self.judgeBall(ball: ball) < 0{
                        hitBall = ball
                        break
                    }
                }
            }else if manTurn < 0{
                for ball in self.ballArray!{
                    if self.judgeBall(ball: ball) > 0{
                        hitBall = ball
                        break
                    }
                }
            }else{
                hitBall = self.ball8!
            }
        }else{
            hitBall = self.ball1!
        }
        
        a = (self.whiteBall?.center.x)! - hitBall.center.x
        b = (self.whiteBall?.center.y)! - hitBall.center.y
        c = -50
        d = 0
        var reds = acos((a * c + b * d) / (sqrt(a * a + b * b) * sqrt(c * c + d * d)))
        if (b > 0) {
            reds = -reds
        }
        
//        if self.circleAngle(angle: 0, point: (self.whiteBall?.center)!, center: hitBall.center){
//            reds = reds - angle!
//            if reds < 0{
//                reds = reds + CGFloat.pi*2
//            }
//        }else{
//            if angle! < 0{
//                angle = 0 - angle!
//            }
//
//            reds = -(angle! - reds + CGFloat.pi*2)
//            if reds > 0{
//                reds = reds - CGFloat.pi*2
//            }
//            if reds < -CGFloat.pi*2{
//                reds = reds + CGFloat.pi*2
//            }
//        }
        
        angle = reds
        return angle
    }
    
    //判断球是大瓣还是小瓣: 1大瓣，-1小瓣,0为8号球
    func judgeBall(ball : BallView?) -> Int{
        var turn : Int = 0
        switch ball?.name {
        case .WHITEB?:
            turn = -1
        case .BALL1?:
            turn = -1
        case .BALL2?:
            turn = -1
        case .BALL3?:
            turn = -1
        case .BALL4?:
            turn = -1
        case .BALL5?:
            turn = -1
        case .BALL6?:
            turn = -1
        case .BALL7?:
            turn = -1
        case .BALL8?:
            turn = 0
        case .BALL9?:
            turn = 1
        case .BALL10?:
            turn = 1
        case .BALL11?:
            turn = 1
        case .BALL12?:
            turn = 1
        case .BALL13?:
            turn = 1
        case .BALL14?:
            turn = 1
        case .BALL15?:
            turn = 1
        default:
            turn = 0
        }
        return turn
    }
    
    //MARK: -
    //输
    func failGame(){
        HubView.showTip(tip: "您输了", vc: self)
        self.isCanBegin = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.clickClose(UIButton())
        }
        
    }
    
    func winGame(){
        HubView.showTip(tip: "恭喜您赢了", vc: self)
        UserManger.shareIntance.changeMoney(addMoney: (self.gameMoney ?? 200)*2)
        self.isCanBegin = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.clickClose(UIButton())
        }
    }
    
    //输赢 输：-1，赢：1，其他：0
    func winOrFail() -> Int{
        var gameResult : Int = 0
        let manArrCount = self.manGoalArr?.count
        let machineArrCount = self.machineGoalArr?.count
        var manBall : BallView = BallView()
        if manArrCount! > 0{
            manBall = (self.manGoalArr?.last)!
        }
        
        var machineBall : BallView = BallView()
        if machineArrCount! > 0{
            machineBall = (self.machineGoalArr?.last)!
        }
        
        //赢
        if manArrCount == 8 && manBall.name == BALLTYPE.BALL8{
            gameResult = 1
        }
        //输
        if (machineArrCount! == 8 && machineBall.name == BALLTYPE.BALL8) || (manArrCount! < 8 && manBall.name == BALLTYPE.BALL8){
            gameResult = -1
        }
        
        return gameResult
    }
    
    //进球判定
    func goal(item : UIDynamicItem){
        let ball = item as! BallView
        if ball.name == BALLTYPE.WHITEB{
            return
        }
        ball.removeFromSuperview()
        self.collision?.removeItem(ball)
        var removeInt : Int = -1
        for i in 0 ..< (self.ballArray?.count)! {
            let arrBall = self.ballArray![i]
            if ball.name == arrBall.name{
                removeInt = i
            }
        }
        
        
        if removeInt != -1{
            self.ballArray?.remove(at: removeInt)
        }else{
            return
        }
        
        
        
        let manCount = self.manGoalArr?.count
        let machineCount = self.machineGoalArr?.count
        var manBall : BallView = BallView()
        if manCount! > 0{
            manBall = (self.manGoalArr?.last)!
        }
        var machineBall : BallView = BallView()
        if machineCount! > 0{
            machineBall = (self.machineGoalArr?.last)!
        }
        
        let ballInt = self.judgeBall(ball: ball)
        //机器轮次
        if self.isMachineTrun!{
            if machineCount! > 0 && machineCount! <= 6{
                if ballInt == self.judgeBall(ball: machineBall){
                    HubView.showTip(tip: "对手进：\(self.readBall(ball: ball))", vc: self)
                    self.isGoal = true
                    self.machineGoalArr?.append(ball)
                }else if ballInt == 0{
                    //赢
                    self.isCanBegin = false
                    self.winGame()
                }else{
                    HubView.showTip(tip: "您进：\(self.readBall(ball: ball))", vc: self)
                    self.manGoalArr?.append(ball)
                }
            }else if machineCount == 7{
                if ballInt == 0{
                    //输
                    self.failGame()
                }else{
                    HubView.showTip(tip: "您进：\(self.readBall(ball: ball))", vc: self)
                    self.manGoalArr?.append(ball)
                }
            }else if machineCount == 0{
                if manCount! > 0{
                    if ballInt == self.judgeBall(ball: manBall){
                        HubView.showTip(tip: "您进：\(self.readBall(ball: ball))", vc: self)
                        self.manGoalArr?.append(ball)
                    }else if ballInt == -self.judgeBall(ball: manBall){
                        HubView.showTip(tip: "对手进：\(self.readBall(ball: ball))", vc: self)
                        self.isGoal = true
                        self.machineGoalArr?.append(ball)
                    }else if ballInt == 0{
                        //赢
                        self.winGame()
                    }
                }else{
                    if ballInt == 0{
                        //赢
                        self.winGame()
                    }else{
                        HubView.showTip(tip: "对手进：\(self.readBall(ball: ball))", vc: self)
                        self.isGoal = true
                        self.machineGoalArr?.append(ball)
                    }
                }
            }
        //玩家轮次
        }else{
            if manCount! > 0 && manCount! <= 6{
                if ballInt == self.judgeBall(ball: manBall){
                    HubView.showTip(tip: "您进：\(self.readBall(ball: ball))", vc: self)
                    self.isGoal = true
                    self.manGoalArr?.append(ball)
                }else if ballInt == 0{
                    //输
                    self.failGame()
                }else{
                    HubView.showTip(tip: "对手进：\(self.readBall(ball: ball))", vc: self)
                    self.machineGoalArr?.append(ball)
                }
            }else if manCount! == 7{
                if ballInt == 0{
                    //赢
                    self.winGame()
                }else{
                    HubView.showTip(tip: "您进：\(self.readBall(ball: ball))", vc: self)
                    self.isGoal = true
                    self.manGoalArr?.append(ball)
                }
            }else if manCount! == 0{
                if machineCount! > 0{
                    if ballInt == self.judgeBall(ball: machineBall){
                        HubView.showTip(tip: "对手进：\(self.readBall(ball: ball))", vc: self)
                        self.machineGoalArr?.append(ball)
                    }else if ballInt == -self.judgeBall(ball: machineBall){
                        HubView.showTip(tip: "您进：\(self.readBall(ball: ball))", vc: self)
                        self.isGoal = true
                        self.manGoalArr?.append(ball)
                    }else{
                        //输
                        self.failGame()
                    }
                }else{
                    if ballInt == 0{
                        //输
                        self.winGame()
                    }else{
                        HubView.showTip(tip: "您进：\(self.readBall(ball: ball))", vc: self)
                        self.isGoal = true
                        self.manGoalArr?.append(ball)
                    }
                }
            }
        }
        
        if self.winOrFail() == -1{
            //输
            self.failGame()
        }else if self.winOrFail() == 1{
            //赢
            self.winGame()
        }
    }
    
    func readBall(ball : BallView) -> String{
        var ballName : String
        switch ball.name! {
        case .WHITEB:
            ballName = "白球"
        case .BALL1:
            ballName = "一号球"
        case .BALL2:
            ballName = "二号球"
        case .BALL3:
            ballName = "三号球"
        case .BALL4:
            ballName = "四号球"
        case .BALL5:
            ballName = "五号球"
        case .BALL6:
            ballName = "六号球"
        case .BALL7:
            ballName = "七号球"
        case .BALL8:
            ballName = "八号球"
        case .BALL9:
            ballName = "九号球"
        case .BALL10:
            ballName = "十号球"
        case .BALL11:
            ballName = "十一号球"
        case .BALL12:
            ballName = "十二号球"
        case .BALL13:
            ballName = "十三号球"
        case .BALL14:
            ballName = "十四号球"
        case .BALL15:
            ballName = "十五号球"
        default:
            ballName = "白球"
        }
        
        return ballName
    }
    

    //MARK: - set up
    func resetGame(){
        //力量
        if self.energyView == nil{
            self.energyView = UIView.init()
            self.energyView?.frame = self.energyImageView.frame
//            self.energyView?.backgroundColor = UIColor.red
            self.energyView?.colorChange(color1: UIColor.red, color2: UIColor.yellow)
            self.view.addSubview(self.energyView!)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickEnergy))
            self.energyImageView?.addGestureRecognizer(tap)
            self.energyImageView.isUserInteractionEnabled = true
            self.view.bringSubview(toFront: self.energyImageView)
        }else{
            self.energyView?.frame = self.energyImageView.frame
            self.energyView?.colorChange(color1: UIColor.red, color2: UIColor.yellow)
        }
        
        
        
        //白球
        if self.whiteBall == nil {
            self.whiteBall = BallView.init(frame: CGRect.init(x: 118, y: self.GameView.center.y - self.GameView.frame.origin.y - 7.5, width: 15, height: 15))
            self.whiteBall?.setImage(image: UIImage.init(named: "0")!)
            self.whiteBall?.name = .WHITEB
            self.GameView.addSubview(self.whiteBall!)
        }else{
            self.whiteBall?.frame = CGRect.init(x: 118, y: self.GameView.center.y - self.GameView.frame.origin.y - 7.5, width: 15, height: 15)
        }
        
//一排
        //一号球
        if self.ball1 == nil{
            self.ball1 = BallView.init(frame: CGRect.init(x: 347, y: self.GameView.center.y - self.GameView.frame.origin.y - 7.5, width: 15, height: 15))
            self.ball1?.setImage(image: UIImage.init(named: "1")!)
            self.ball1?.name = .BALL1
            self.GameView.addSubview(self.ball1!)
        }else{
            self.ball1?.frame = CGRect.init(x: 347, y: self.GameView.center.y - self.GameView.frame.origin.y - 7.5, width: 15, height: 15)
        }
//二排
        //二号球
        if self.ball2 == nil{
            self.ball2 = BallView.init(frame: CGRect.init(x: (self.ball1?.center.x)! + 7.5, y: (self.ball1?.center.y)! - 15, width: 15, height: 15))
            self.ball2?.setImage(image: UIImage.init(named: "2")!)
            self.ball2?.name = .BALL2
            self.GameView.addSubview(self.ball2!)
        }else{
            self.ball2?.frame = CGRect.init(x: (self.ball1?.center.x)! + 7.5, y: (self.ball1?.center.y)! - 15, width: 15, height: 15)
        }
        
        //十五号球
        if self.ball15 == nil{
            self.ball15 = BallView.init(frame: CGRect.init(x: (self.ball2?.center.x)! - 7.5, y: (self.ball2?.center.y)! + 7.5, width: 15, height: 15))
            self.ball15?.setImage(image: UIImage.init(named: "15")!)
            self.ball15?.name = .BALL15
            self.GameView?.addSubview(self.ball15!)
        }else{
            self.ball15?.frame = CGRect.init(x: (self.ball2?.center.x)! - 7.5, y: (self.ball2?.center.y)! + 7.5, width: 15, height: 15)
        }
//三排
        //十四号球
        if self.ball14 == nil{
            self.ball14 = BallView.init(frame: CGRect.init(x: (self.ball2?.center.x)! + 7.5, y: (self.ball2?.center.y)! - 15, width: 15, height: 15))
            self.ball14?.setImage(image: UIImage.init(named: "14")!)
            self.ball15?.name = .BALL14
            self.GameView.addSubview(self.ball14!)
        }else{
            self.ball14?.frame = CGRect.init(x: (self.ball2?.center.x)! + 7.5, y: (self.ball2?.center.y)! - 15, width: 15, height: 15)
        }
        
        //八号球
        if self.ball8 == nil{
            self.ball8 = BallView.init(frame: CGRect.init(x: (self.ball14?.center.x)! - 7.5, y: (self.ball14?.center.y)! + 7.5, width: 15, height: 15))
            self.ball8?.setImage(image: UIImage.init(named: "8")!)
            self.ball8?.name = .BALL8
            self.GameView.addSubview(self.ball8!)
        }else{
            self.ball8?.frame = CGRect.init(x: (self.ball14?.center.x)! - 7.5, y: (self.ball14?.center.y)! + 7.5, width: 15, height: 15)
        }
        
        //三号球
        if self.ball3 == nil{
            self.ball3 = BallView.init(frame: CGRect.init(x: (self.ball8?.center.x)! - 7.5, y: (self.ball8?.center.y)! + 7.5, width: 15, height: 15))
            self.ball3?.setImage(image: UIImage.init(named: "3")!)
            self.ball3?.name = .BALL3
            self.GameView.addSubview(self.ball3!)
        }else{
            self.ball3?.frame = CGRect.init(x: (self.ball8?.center.x)! - 7.5, y: (self.ball8?.center.y)! + 7.5, width: 15, height: 15)
        }
//四排
        //十二号球
        if self.ball12 == nil{
            self.ball12 = BallView.init(frame: CGRect.init(x: (self.ball14?.center.x)! + 7.5, y: (self.ball14?.center.y)! - 15, width: 15, height: 15))
            self.ball12?.setImage(image: UIImage.init(named: "12")!)
            self.ball12?.name = .BALL12
            self.GameView.addSubview(self.ball12!)
        }else{
            self.ball12?.frame = CGRect.init(x: (self.ball14?.center.x)! + 7.5, y: (self.ball14?.center.y)! - 15, width: 15, height: 15)
        }
        
        //十三号球
        if self.ball13 == nil{
            self.ball13 = BallView.init(frame: CGRect.init(x: (self.ball12?.center.x)! - 7.5, y: (self.ball12?.center.y)! + 7.5, width: 15, height: 15))
            self.ball13?.setImage(image: UIImage.init(named: "13")!)
            self.ball13?.name = .BALL13
            self.GameView.addSubview(self.ball13!)
        }else{
            self.ball13?.frame = CGRect.init(x: (self.ball12?.center.x)! - 7.5, y: (self.ball12?.center.y)! + 7.5, width: 15, height: 15)
        }
        
        //五号球
        if self.ball5 == nil{
            self.ball5 = BallView.init(frame: CGRect.init(x: (self.ball13?.center.x)! - 7.5, y: (self.ball13?.center.y)! + 7.5, width: 15, height: 15))
            self.ball5?.setImage(image: UIImage.init(named: "5")!)
            self.ball5?.name = .BALL5
            self.GameView.addSubview(self.ball5!)
        }else{
            self.ball5?.frame = CGRect.init(x: (self.ball13?.center.x)! - 7.5, y: (self.ball13?.center.y)! + 7.5, width: 15, height: 15)
        }
        
        //四号球
        if self.ball4 == nil{
            self.ball4 = BallView.init(frame: CGRect.init(x: (self.ball5?.center.x)! - 7.5, y: (self.ball5?.center.y)! + 7.5, width: 15, height: 15))
            self.ball4?.setImage(image: UIImage.init(named: "4")!)
            self.ball4?.name = .BALL4
            self.GameView.addSubview(self.ball4!)
        }else{
            self.ball4?.frame = CGRect.init(x: (self.ball5?.center.x)! - 7.5, y: (self.ball5?.center.y)! + 7.5, width: 15, height: 15)
        }
//五排
        //七号球
        if self.ball7 == nil{
            self.ball7 = BallView.init(frame: CGRect.init(x: (self.ball12?.center.x)! + 7.5, y: (self.ball12?.center.y)! - 15, width: 15, height: 15))
            self.ball7?.setImage(image: UIImage.init(named: "7")!)
            self.ball7?.name = .BALL7
            self.GameView.addSubview(self.ball7!)
        }else{
            self.ball7?.frame = CGRect.init(x: (self.ball12?.center.x)! + 7.5, y: (self.ball12?.center.y)! - 15, width: 15, height: 15)
        }
        
        //九号球
        if self.ball9 == nil{
            self.ball9 = BallView.init(frame: CGRect.init(x: (self.ball7?.center.x)! - 7.5, y: (self.ball7?.center.y)! + 7.5, width: 15, height: 15))
            self.ball9?.setImage(image: UIImage.init(named: "9")!)
            self.ball9?.name = .BALL9
            self.GameView.addSubview(self.ball9!)
        }else{
            self.ball9?.frame = CGRect.init(x: (self.ball7?.center.x)! - 7.5, y: (self.ball7?.center.y)! + 7.5, width: 15, height: 15)
        }
        
        //六号球
        if self.ball6 == nil{
            self.ball6 = BallView.init(frame: CGRect.init(x: (self.ball9?.center.x)! - 7.5, y: (self.ball9?.center.y)! + 7.5, width: 15, height: 15))
            self.ball6?.setImage(image: UIImage.init(named: "6")!)
            self.ball6?.name = .BALL6
            self.GameView.addSubview(self.ball6!)
        }else{
            self.ball6?.frame = CGRect.init(x: (self.ball9?.center.x)! - 7.5, y: (self.ball9?.center.y)! + 7.5, width: 15, height: 15)
        }
        
        //十号球
        if self.ball10 == nil{
            self.ball10 = BallView.init(frame: CGRect.init(x: (self.ball6?.center.x)! - 7.5, y: (self.ball6?.center.y)! + 7.5, width: 15, height: 15))
            self.ball10?.setImage(image: UIImage.init(named: "10")!)
            self.ball10?.name = .BALL10
            self.GameView.addSubview(self.ball10!)
        }else{
            self.ball10?.frame = CGRect.init(x: (self.ball6?.center.x)! - 7.5, y: (self.ball6?.center.y)! + 7.5, width: 15, height: 15)
        }
        
        //十一号球
        if self.ball11 == nil{
            self.ball11 = BallView.init(frame: CGRect.init(x: (self.ball10?.center.x)! - 7.5, y: (self.ball10?.center.y)! + 7.5, width: 15, height: 15))
            self.ball11?.setImage(image: UIImage.init(named: "11")!)
            self.ball11?.name = .BALL11
            self.GameView.addSubview(self.ball11!)
        }else{
            self.ball11?.frame = CGRect.init(x: (self.ball10?.center.x)! - 7.5, y: (self.ball10?.center.y)! + 7.5, width: 15, height: 15)
        }
        
        self.ballArray = [self.ball1, self.ball2, self.ball3, self.ball4, self.ball5, self.ball6, self.ball7, self.ball8, self.ball9, self.ball10, self.ball11, self.ball12, self.ball13, self.ball14, self.ball15] as? [BallView]

    }
    
}

//运动行为监测
extension GameViewController : UIDynamicAnimatorDelegate{
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        //
        if !isGoal!{
            
            self.isMachineTrun = !self.isMachineTrun!
        }
        
        self.isCanBegin = true
        self.oldAngle = 0
//        let whitePoint = self.whiteBall?.center
//        print("pause x = \(whitePoint?.x)  y = \(whitePoint?.y)")
        let baseHeight = self.GameView.frame.size.height
        let baseWidth = self.GameView.frame.size.width
        let x : CGFloat = (self.whiteBall?.center.x)!
        let y : CGFloat = (self.whiteBall?.center.y)!
        
        if (x < CGFloat(0)) || (y < CGFloat(0)) || (x > baseWidth) || (y > baseHeight){
            self.whiteBall?.center = CGPoint.init(x: 125.5, y: self.GameView.center.y/2)
        }
        self.machineHit()
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        //
    }
}

//碰撞行为监测
extension GameViewController : UICollisionBehaviorDelegate{
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let baseHeight = self.GameView.frame.size.height
        let baseWidth = self.GameView.frame.size.width
        let x = p.x
        let y = p.y
//        let whiteItem = self.whiteBall as! UIDynamicItem
        let ball = item as! BallView
//        print("collision x = \(p.x) y = \(p.y)")
        
        if x < 0{
            ball.center = CGPoint.init(x: 9.5, y: ball.center.y)
        }
        
        if y < 0{
            ball.center = CGPoint.init(x: ball.center.x, y: 9.5)
        }
        
        if x > baseWidth - 7.5{
            ball.center = CGPoint.init(x: baseWidth - 10, y: ball.center.y)
        }
        
        if y > baseHeight - 5{
            ball.center = CGPoint.init(x: ball.center.x, y: baseHeight - 9.5)
        }
        
        if ball.name == self.whiteBall?.name{
            return
        }
        //左上角
        if x <= 18 && y <= 18{
            self.goal(item: item)
        }

        //中间上
        if x >= baseWidth/2 - 9 && x <= baseWidth/2 + 9  && y <= 18{
            self.goal(item: item)
        }

        //右上角
        if x >= baseWidth - 18 && y <= 18{
            self.goal(item: item)
        }
        
        //左下角
        if x <= 18 && y >= baseHeight - 18{
            self.goal(item: item)
        }
        
        //中间下
        if x >= baseWidth/2 - 9 && x <= baseWidth/2 + 9 && y >= baseHeight - 18{
            self.goal(item: item)
        }
        
        //右下角
        if x >= baseWidth - 18 && y > baseHeight - 18{
            self.goal(item: item)
        }
        
    }
}
