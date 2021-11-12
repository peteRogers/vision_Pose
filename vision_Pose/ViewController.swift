//
//  ViewController.swift
//  vision_Pose
//
//  Created by Peter Rogers on 09/11/2021.
//

import UIKit
import Combine

class ViewController: UIViewController {

    
    private var cameraViewController: CameraViewController!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraViewController = CameraViewController()
        cameraViewController.view.frame = view.bounds
        addChild(cameraViewController)
        cameraViewController.beginAppearanceTransition(true, animated: true)
        view.addSubview(cameraViewController.view)
        cameraViewController.endAppearanceTransition()
        cameraViewController.didMove(toParent: self)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        do {
       
            try cameraViewController.setupAVSession()
            
                   } catch {
                      // AppError.display(error, inViewController: self)
                   }
    }
    
    func magic(text:String){
        
    }

}

