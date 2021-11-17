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
    let substractSize: CGFloat = 200

    var innerRadius: CGFloat = 0.0

    let joystickSubstractView = UIView()
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

      


        // if you want the "joystick" circle to overlap the "outer circle" a bit, adjust this value
        innerRadius = (substractSize - joystickSize) * 0.5


        // start debugging / clarification...
        // add a center "dot" to the joystick view
        // add a red circle showing the inner radius - where we want to restrict the center of the joystick view
      
       // print(v.frame.midY)
        // end debugging / clarification

    }

    func lineLength(from pt1: CGPoint, to pt2: CGPoint) -> CGFloat {
        return hypot(pt2.x - pt1.x, pt2.y - pt1.y)
    }

    func pointOnLine(from startPt: CGPoint, to endPt: CGPoint, distance: CGFloat) -> CGPoint {
        let totalDistance = lineLength(from: startPt, to: endPt)
        let totalDelta = CGPoint(x: endPt.x - startPt.x, y: 0 - 0)
        let pct = distance / totalDistance;
        let delta = CGPoint(x: totalDelta.x * pct, y: totalDelta.y * pct)
        return CGPoint(x: startPt.x + delta.x, y: startPt.y + delta.y)
    }

    @objc func dragJoystick(_ sender: UIPanGestureRecognizer) {

      //  let touchLocation = sender.location(in: joystickSubstractView)
       // print(sender.location(in:self.view).x - (view.frame.midX))
       
        var pos = sender.location(in:self.view).x - (view.frame.midX)
        print(pos)
        if(pos > view.frame.width / 8){
            pos = view.frame.width / 8
        }else if(abs(pos) > view.frame.width / 8){
            pos = -((view.frame.width) / 8)
        }
        let p = abs(pos)
        joystickView.layer.removeAllAnimations()
       //if(sender.location(in:self.view).x < )
        joystickView.center.x = view.frame.midX + pos
        if(sender.state == UIGestureRecognizer.State.ended){
            UIView.animate(withDuration: p/1000, animations: {
                self.joystickView.center.x = self.view.frame.midX
            })
        }
        
      

    }

}
