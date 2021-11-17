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
