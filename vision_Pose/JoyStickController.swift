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
    
    let myCyan = UIColor(red: 0, green: 246/255, blue: 255/255, alpha: 1)
    let myMagenta = UIColor(red: 1, green: 0, blue: 106/255, alpha: 1)
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
        joystickView.backgroundColor = myMagenta
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
//        let pushGesture = UITapGestureRecognizer(target: self, action: #selector(pushGesture(_:)))
        let pushGesture = UILongPressGestureRecognizer(target: self, action: #selector(pushGesture(_:)))
        pushGesture.minimumPressDuration = 0.1
        buttonView.isUserInteractionEnabled = true
        buttonView.addGestureRecognizer(pushGesture)
        buttonView.backgroundColor = myMagenta
        buttonView.layer.cornerRadius = CGFloat((bnCenterView.frame.size.width / (js/1.5))/2)
        buttonView.frame = CGRect(x: bnCenterView.frame.midX-((bnCenterView.frame.size.width/(js/1.5))/2),
                                  y: view.frame.midY-((bnCenterView.frame.size.width/js)/1.25),
                                  width: bnCenterView.frame.size.width/(js/1.5),
                                  height: bnCenterView.frame.size.width/(js/1.5))
        buttonView.center.y = bnCenterView.frame.midY - (bnCenterView.frame.height/8)
        view.addSubview(buttonView)
        
        let button = UIButton(frame: CGRect(x: 20, y: 20, width: 200, height: 60))
         button.setTitle("Email", for: .normal)
         button.backgroundColor = .white
         button.setTitleColor(UIColor.black, for: .normal)
         button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
   @objc func buttonTapped(sender:UIButton!) {
       self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pushGesture(_ sender: UIGestureRecognizer){
        
        //print("tapped")
        buttonView.backgroundColor = myCyan
        if(sender.state == UIGestureRecognizer.State.ended){
            buttonView.backgroundColor = myMagenta
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
                self.buttonView.center.y = self.bnCenterView.frame.midY - (self.bnCenterView.frame.height/8)
                //self.joystickView.backgroundColor = self.myMagenta
            })
        }else{
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                self.buttonView.center.y = self.bnCenterView.frame.midY
                //self.joystickView.backgroundColor = self.myMagenta
            })
        }
    }

    @objc func dragJoystick(_ sender: UIPanGestureRecognizer) {
        var pos = sender.location(in:self.view).x
        print("\(pos): \(jsCenterView.frame.midX + jsCenterView.frame.width/2)" )
        if(pos > jsCenterView.frame.midX + jsCenterView.frame.width/2){
            pos = jsCenterView.frame.midX + jsCenterView.frame.width/2
        }else if(pos < jsCenterView.frame.midX - jsCenterView.frame.width/2){
            pos = jsCenterView.frame.midX - jsCenterView.frame.width/2
        }
        joystickView.backgroundColor = myCyan
        joystickView.layer.removeAllAnimations()
        joystickView.center.x = pos
        let p = abs(pos-jsCenterView.frame.midX)
        print(p)
        if(sender.state == UIGestureRecognizer.State.ended){
            UIView.animate(withDuration: p/500, delay: 0.0, options: .curveEaseInOut, animations: {
                self.joystickView.center.x = self.jsCenterView.frame.midX
                self.joystickView.backgroundColor = self.myMagenta
            })
        }
    }
}
