//
//  JoyStickController.swift
//  vision_Pose
//
//  Created by dt on 17/11/2021.
//

import Foundation
import UIKit
import SnapKit

class JoyStickController: UIViewController {

    let joystickSize: CGFloat = 150
    let joystickView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let jsCenterView = UIView()
        jsCenterView.backgroundColor = .gray
        jsCenterView.layer.cornerRadius = self.view.frame.height/4
        view.addSubview(jsCenterView)
        jsCenterView.frame = CGRect(x: view.frame.midX-((self.view.frame.height/2)/2) ,
                                    y: view.frame.midY-((self.view.frame.height/2)/2)+(self.view.frame.height/16),
                                    width: self.view.frame.height/2, height: self.view.frame.height/2)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragJoystick(_:)))
        joystickView.isUserInteractionEnabled = true
        joystickView.addGestureRecognizer(panGesture)
        joystickView.backgroundColor = .yellow
        joystickView.layer.cornerRadius = CGFloat(joystickSize / 2)
        joystickView.frame = CGRect(x: view.frame.midX-(joystickSize/2), y: view.frame.midY-(joystickSize/2), width: joystickSize, height: joystickSize)
        view.addSubview(joystickView)
    }



    @objc func dragJoystick(_ sender: UIPanGestureRecognizer) {
        var pos = sender.location(in:self.view).x - (view.frame.midX)
        print(pos)
        if(pos > view.frame.width / 8){
            pos = view.frame.width / 8
        }else if(abs(pos) > view.frame.width / 8){
            pos = -((view.frame.width) / 8)
        }
        let p = abs(pos)
        joystickView.layer.removeAllAnimations()
        joystickView.center.x = view.frame.midX + pos
        if(sender.state == UIGestureRecognizer.State.ended){
            UIView.animate(withDuration: p/1000, animations: {
                self.joystickView.center.x = self.view.frame.midX
            })
        }
    }
}
