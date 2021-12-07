//
//  ClockView.swift
//  vision_Pose
//
//  Created by Peter Rogers on 07/12/2021.
//

import UIKit

class ClockView: UIView {
    
    var text: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        text = UITextField(frame: frame)
        
        text?.text = "hello"
        text?.font = UIFont.systemFont(ofSize: 100)
        //text?.contentVerticalAlignment = .center
        text?.textAlignment = .center
            //textField.borderStyle = UITextField.BorderStyle.roundedRect
        text?.backgroundColor = .white
        text?.isEnabled = false
        addSubview(text!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
