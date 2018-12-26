////
////  MusicManager.swift
////  KY28Game
////
////  Created by JACK on 2018/10/31.
////  Copyright © 2018年 sherily. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class MusicManager: NSObject {
//
//    var isBgMusic : Bool? = true
//    var isButtonMusic : Bool? = true
//
//    var bgMusic : AVAudioPlayer?
//    var buttnMusic : AVAudioPlayer?
//
//    private override init() {
//        //
//    }
//
//    static let shareInstance = MusicManager()
//
//    func onBgMusic(){
//        let bgmusicPath = Bundle.main.path(forResource: "bgmusic", ofType: ".mp3")
//        let url = NSURL.init(fileURLWithPath: bgmusicPath!)
//        do{
//            try self.bgMusic = AVAudioPlayer.init(contentsOf: url as URL)
//        }
//        catch{
//
//        }
//
//        self.bgMusic?.numberOfLoops = -1
//        self.bgMusic?.volume = 0.5
//        self.bgMusic?.prepareToPlay()
//        self.bgMusic?.play()
//
//    }
//
//    func offBgMusic(){
//        self.isBgMusic = false
//        self.bgMusic?.stop()
//    }
//
//    func openBgMusic(){
//        self.isBgMusic = true
//        self.bgMusic?.play()
//    }
//
//    func setBgMusicValue(value : Float){
//        self.bgMusic?.volume = value
//    }
//
//
//
//    func onButtonMusic(){
//        let buttonPath = Bundle.main.path(forResource: "click", ofType: ".mp3")
//        let url = NSURL.init(fileURLWithPath: buttonPath!)
//        self.buttnMusic?.numberOfLoops = -1
//        self.buttnMusic?.volume = 0.5
//        self.buttnMusic?.prepareToPlay()
//        do{
//            try self.buttnMusic = AVAudioPlayer.init(contentsOf: url as URL)
//        }
//        catch{
//
//        }
//        if self.isButtonMusic!{
//            self.buttnMusic?.play()
//        }
//
//    }
//
//    func openButtonMusic(){
//        self.isButtonMusic = true
//    }
//
//    func offButtonMusic(){
//        self.isButtonMusic = false
//    }
//
//    func setButtonMusicValue(value : Float){
//        self.buttnMusic?.volume = value
//    }
//
//}
//
//extension UIButton {
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        let music = MusicManager.shareInstance
//        music.onButtonMusic()
//    }
//}
//
