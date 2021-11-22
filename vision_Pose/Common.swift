//
//  Common.swift
//  vision_Pose
//
//  Created by Peter Rogers on 16/11/2021.
//

import Foundation
import UIKit

struct SprinkleMessage {
    let pos:CGFloat
    let hit:Int
}


enum connectionStatus {
    case connecting
    case connected
    case disconnected
    case previewing
    case disconnecting
    case preview
    case unauthorized
}

extension UIColor{
    static var myCyan:UIColor{
        UIColor(red: 0, green: 246/255, blue: 255/255, alpha: 1)
    }
    
    static var myMagenta:UIColor{
        UIColor(red: 1, green: 0, blue: 106/255, alpha: 1)
    }
    
    
    
}


extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}
