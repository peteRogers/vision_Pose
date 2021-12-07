//
//  ViewController.swift
//  vision_Pose
//
//  Created by Peter Rogers on 09/11/2021.
//

import UIKit
import Combine


class ViewController: UIViewController {

    
    private var cameraViewController: CameraViewController?
    
    @IBOutlet weak var connectButton: UIButton!
    
    @IBOutlet weak var manualConnectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    @IBAction func actionConnectManual(_ sender: UIButton) {
        let joy = JoyStickController()
        joy.view.frame = view.bounds
       
        joy.view.frame = view.bounds
        
        self.present(joy, animated: true, completion: nil)
    }
    
    
    @IBAction func actionConnect(_ sender: UIButton) {
        cameraViewController = CameraViewController()
        cameraViewController?.view.frame = view.frame
        do {
       
            try cameraViewController?.setupAVSession()
            
                   } catch {
                      // AppError.display(error, inViewController: self)
                   }
        
        cameraViewController?.view.frame = view.bounds
        cameraViewController?.modalPresentationStyle = .fullScreen 
        self.present(cameraViewController!, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    func magic(text:String){
        
    }

}

