//
//  StateView.swift
//  ObjectDetection
//
//  Created by dt on 16/04/2020.
//  Copyright © 2020 MachineThink. All rights reserved.
//

import UIKit


class StateView: UIView {
    
    
   
   
    private var mainButton:UIButton?
    var killConnection: (() -> Void)?
   
   
    func setStatus(con:connectionStatus){
        if(con == .connected){
            mainButton?.setTitle("CLOSE", for: .normal)
        }
        
        if(con == .connecting){
            mainButton?.setTitle("CONNECTING", for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        let font = UIFont.init(name: "PingFangSC-Semibold", size: self.frame.height / 1.6)
        mainButton = UIButton(frame: frame)
        self.addSubview(mainButton!)
        mainButton?.layer.cornerRadius = self.frame.height/3
        mainButton?.backgroundColor = .myMagenta
        mainButton?.setTitle("DISCONNECTED", for: .normal)
        mainButton?.titleLabel?.font = font
        mainButton?.setTitleColor(.myCyan, for: .normal)
        mainButton?.addTarget(self,
                               action: #selector(quitAction),
                               for: .touchUpInside)
      
    }
    
    
    @objc func quitAction(_sender:Any){
        self.killConnection?()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    

}




