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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       // addChild(cameraViewController)
       
      // cameraViewController.beginAppearanceTransition(true, animated: true)
        //view.addSubview(cameraViewController.view)
      //  cameraViewController.endAppearanceTransition()
       // cameraViewController.didMove(toParent: self)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func actionConnect(_ sender: UIButton) {
        cameraViewController = CameraViewController()
        cameraViewController?.view.frame = view.bounds
        do {
       
            try cameraViewController?.setupAVSession()
            
                   } catch {
                      // AppError.display(error, inViewController: self)
                   }
       // cameraViewController.view.frame = view.bounds
       // camer
        cameraViewController?.view.frame = view.bounds
        
        self.present(cameraViewController!, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let joy = JoyStickController()
        joy.view.frame = view.bounds
       
        joy.view.frame = view.bounds
        
        self.present(joy, animated: true, completion: nil)
    }
    
    func magic(text:String){
        
    }

}

