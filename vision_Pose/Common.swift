//
//  Common.swift
//  vision_Pose
//
//  Created by Peter Rogers on 09/11/2021.
//

import Foundation
import UIKit

extension CGAffineTransform {
    static var verticalFlip = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
}
