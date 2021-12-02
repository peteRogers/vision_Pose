//
//  JoyStickController.swift
//  vision_Pose
//
//  Created by dt on 17/11/2021.
//

import Foundation
import UIKit


class JoyStickController: UIViewController {

    
    let joystickView = UIView()
    let jsCenterView = UIView()
    let bnCenterView = UIView()
    let buttonView = UIView()
    var ble = BLEController()
    private var stateView: StateView?
    let notificationCenter = NotificationCenter.default
    private var displayLink:CADisplayLink?
    var pressed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let js = 2.0
       
        jsCenterView.backgroundColor = .gray
        jsCenterView.layer.cornerRadius = self.view.frame.height/4
        view.addSubview(jsCenterView)
        jsCenterView.frame = CGRect(x: view.frame.height/4,
                                    y: view.frame.midY-((self.view.frame.height/2)/2)+(self.view.frame.height/16),
                                    width: self.view.frame.height/2, height: self.view.frame.height/2)
        jsCenterView.center.x = self.view.frame.width / 4
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick(_:)))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = .myMagenta
        joystickView.layer.cornerRadius = CGFloat((jsCenterView.frame.size.width / js)/2)
        joystickView.frame = CGRect(x: jsCenterView.frame.midX-((jsCenterView.frame.size.width/js)/2), y: view.frame.midY-((jsCenterView.frame.size.width/js)/1.25), width: jsCenterView.frame.size.width/js, height: jsCenterView.frame.size.width/js)
        view.addSubview(joystickView)
        
        bnCenterView.backgroundColor = .gray
        bnCenterView.layer.cornerRadius = self.view.frame.height/4
        view.addSubview(bnCenterView)
        bnCenterView.frame = CGRect(x:(view.frame.width/2)+(view.frame.height / 4),
                                    y: view.frame.midY-((self.view.frame.height/2)/2)+(self.view.frame.height/16),
                                    width: self.view.frame.height/2, height: self.view.frame.height/2)
        view.addSubview(bnCenterView)
        bnCenterView.center.x = self.view.frame.width - self.view.frame.width/4

        let pushGesture = UILongPressGestureRecognizer(target: self, action: #selector(pushGesture(_:)))
        pushGesture.minimumPressDuration = 0.1
        buttonView.isUserInteractionEnabled = true
        buttonView.addGestureRecognizer(pushGesture)
        buttonView.backgroundColor = .myMagenta
        buttonView.layer.cornerRadius = CGFloat((bnCenterView.frame.size.width / (js/1.5))/2)
        buttonView.frame = CGRect(x: bnCenterView.frame.midX-((bnCenterView.frame.size.width/(js/1.5))/2),
                                  y: view.frame.midY-((bnCenterView.frame.size.width/js)/1.25),
                                  width: bnCenterView.frame.size.width/(js/1.5),
                                  height: bnCenterView.frame.size.width/(js/1.5))
        buttonView.center.y = bnCenterView.frame.midY - (bnCenterView.frame.height/16)
        view.addSubview(buttonView)
        
     
        self.view.backgroundColor = .darkText
        
        notificationCenter.addObserver(self, selector: #selector(quitJoystick), name: UIApplication.willResignActiveNotification, object: nil)
        launchBLE()
        createUI()
    }
    
    func createDisplayLink() {
        if let _ = displayLink {
            displayLink?.isPaused = false
        }else{
          
            displayLink = CADisplayLink(target: self,
                                            selector: #selector(step))
            displayLink?.add(to: .current,
                            forMode: .common)
        }
       
        
       
    }
    
    @objc func step(){
        let t = (joystickView.layer.presentation()?.frame.midX ?? 0) - (jsCenterView.center.x)
        self.mapSendDirectionOutput(inValue: t)
    }
    
    func createUI(){
 
        stateView = StateView.init(frame: CGRect(x: 0,y: self.view.frame.height/32, width:self.view.frame.width/2, height: self.view.frame.height / 6))
        stateView?.center.x = self.view.frame.midX
        self.view.addSubview(stateView!)
        stateView?.killConnection = {
            self.quitJoystick()
        
        }
    }
    
    
 
    
    func launchBLE(){
        print("launch ble")
        ble.connect()
        ble.connectionChanged = { [unowned self] value in
            let v = value as connectionStatus
            if(v == .disconnected){
                self.quitJoystick()
                print("disconnected")
            }
            stateView?.setStatus(con: v)
        }
    }
    
    @objc func quitJoystick(){
        print("quitting")
        
        if(ble.isConnected() == true){
            ble.disconnect()
            
        }
        notificationCenter.removeObserver(self, name:UIApplication.willResignActiveNotification, object: nil)
        self.dismiss(animated: true, completion: nil)
        
        if let _ = displayLink{
            displayLink?.invalidate()
        }
    }
    
    func mapSendDirectionOutput(inValue:CGFloat){
        
        let sp = inValue.map(from: -((jsCenterView.frame.width)/2) ... ((jsCenterView.frame.width)/2), to: -255 ... 255)
        var p = 0
        if(self.pressed == true){
            p = 1
        }
        let m = SprinkleMessage(pos: sp, hit: p, hitMessage: 0)
        
        ble.addData(message: m)
        }
    
  
    
    @objc func pushGesture(_ sender: UIGestureRecognizer){
        
        //print("tapped")
        buttonView.backgroundColor = .myCyan
        if(sender.state == UIGestureRecognizer.State.began){
            self.pressed = true
            let s = SprinkleMessage(pos: 0, hit: 1,hitMessage: 1)
            self.ble.addData(message: s)
            
        }
        if(sender.state == UIGestureRecognizer.State.ended){
            buttonView.backgroundColor = .myMagenta
            self.pressed = false
            let s = SprinkleMessage(pos: 0, hit: 0, hitMessage: 1)
            self.ble.addData(message: s)
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut, animations: {
                self.buttonView.center.y = self.bnCenterView.frame.midY - (self.bnCenterView.frame.height/16)
            })
        }else{
            UIView.animate(withDuration: 0.01, delay: 0.0, options: .curveEaseInOut, animations: {
                self.buttonView.center.y = self.bnCenterView.frame.midY
            })
        }
    }

    @objc func dragJoystick(_ sender: UIPanGestureRecognizer) {
        var pos = sender.location(in:jsCenterView).x - (jsCenterView.frame.width / 2)
        
        if(pos > jsCenterView.frame.width / 2){
            pos = jsCenterView.frame.width / 2
        }
        
        if(pos < -jsCenterView.frame.width / 2){
            pos = -jsCenterView.frame.width / 2
        }
        joystickView.backgroundColor = .myCyan
        joystickView.layer.removeAllAnimations()
        joystickView.center.x = jsCenterView.center.x + pos
        if(sender.state == UIGestureRecognizer.State.began){
            self.createDisplayLink()
        }
        if(sender.state == UIGestureRecognizer.State.ended){
            let p = abs(pos)
            UIView.animate(withDuration: p/500, delay: 0.0, options: .curveEaseInOut, animations: {
                self.joystickView.center.x = self.jsCenterView.frame.midX
                self.joystickView.backgroundColor = .myMagenta
               
            }, completion: {_ in
                self.displayLink?.isPaused = true
                let s = SprinkleMessage(pos: 0, hit: 0, hitMessage:0)
                self.ble.addData(message: s)
        })
                           }
    }
}
