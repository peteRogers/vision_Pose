//
//  CameraViewController.swift
//  vision_Pose
//
//  Created by Peter Rogers on 09/11/2021.
//



import UIKit
import AVFoundation
import Vision

//protocol CameraViewControllerOutputDelegate: AnyObject {
//    func cameraViewController(_ controller: CameraViewController, didReceiveBuffer buffer: CMSampleBuffer, orientation: CGImagePropertyOrientation)
//}

class CameraViewController: UIViewController {
    
  //  weak var outputDelegate: CameraViewControllerOutputDelegate?
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInitiated,
                                                     attributes: [], autoreleaseFrequency: .workItem)

    // Live camera feed management
    private var cameraFeedView: CameraFeedView!
    private var cameraFeedSession: AVCaptureSession?
    private var stateView: StateView?
    var request: VNDetectHumanRectanglesRequest!
    var visionToAVFTransform = CGAffineTransform.identity
    
    var ble = BLEController()
    let notificationCenter = NotificationCenter.default
   

    override func viewDidLoad() {
        super.viewDidLoad()
       
       // pass("foof")
        request = VNDetectHumanRectanglesRequest(completionHandler: recognizeHumans)
       // let value = UIInterfaceOrientation.landscapeRight.rawValue
       // UIDevice.current.setValue(value, forKey: "orientation")
      //  print()
        notificationCenter.addObserver(self, selector: #selector(quitCamera), name: UIApplication.willResignActiveNotification, object: nil)
        launchBLE()
       
    }
    
    func launchBLE(){
        print("launch ble")
        ble.connect()
        ble.connectionChanged = { [unowned self] value in
            let v = value as connectionStatus
            if(v == .disconnected){
                self.quitCamera()
                print("disconnected")
            }
            //self.stateManager(state: value)
            stateView?.setStatus(con: v)
            print(v)
        }
      
        
    }
    
   @objc func quitCamera(){
       print("quitting")
            
            if(ble.isConnected() == true){
                ble.disconnect()
               // triedButFailed = false
            }
        
//            videoView?.videoCapture.stop()
//            videoView?.removeFromSuperview()
//            videoView = nil
//            UIApplication.shared.isIdleTimerDisabled = false
//            egg.stopAll()
       // self.dismiss(animated: true, completion: nil)
        self.cameraFeedView.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
        self.removeFromParent()
       notificationCenter.removeObserver(self, name:UIApplication.willResignActiveNotification, object: nil)
    }
    
    func recognizeHumans(request:VNRequest, error: Error?){
        
        var redBoxes = [CGRect]()
        guard let results = request.results as? [VNHumanObservation] else {
            return
        }
        for result in results{
          //  print(result.boundingBox.minX)
            redBoxes.append(result.boundingBox)
            show(boxGroups: [(color: UIColor.red.cgColor, boxes: redBoxes)])
            
        }
    }
    
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop capture session if it's running
        
        
        cameraFeedSession?.stopRunning()
        ble.disconnect()
       print("view disapeared maybe")
    }
    
    func setupAVSession() throws {
        // Create device discovery session for a wide angle camera
        let wideAngle = AVCaptureDevice.DeviceType.builtInWideAngleCamera
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [wideAngle], mediaType: .video, position: .front)
        
        // Select a video device, make an input
        guard let videoDevice = discoverySession.devices.first else {
           // throw AppError.captureSessionSetup(reason: "Could not find a wide angle camera device.")
            print("could not find wide angle camera")
            return
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("could not find video input")
            return
           // throw AppError.captureSessionSetup(reason: "Could not create video device input.")
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        // We prefer a 1080p video capture but if camera cannot provide it then fall back to highest possible quality
        if videoDevice.supportsSessionPreset(.hd1920x1080) {
            session.sessionPreset = .hd1920x1080
        } else {
            session.sessionPreset = .high
        }
        
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            return
           // throw AppError.captureSessionSetup(reason: "Could not add video device input to the session")
        }
        session.addInput(deviceInput) 
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [
                String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
           // throw AppError.captureSessionSetup(reason: "Could not add video data output to the session")
        }
        let captureConnection = dataOutput.connection(with: .video)
        captureConnection?.preferredVideoStabilizationMode = .standard
        // Always process the frames
        captureConnection?.isEnabled = true
        session.commitConfiguration()
        cameraFeedSession = session
        
        // Get the interface orientaion from window scene to set proper video orientation on capture connection.
        let videoOrientation: AVCaptureVideoOrientation
        switch view.window?.windowScene?.interfaceOrientation {
        case .landscapeRight:
            videoOrientation = .landscapeRight
        default:
            videoOrientation = .portrait
        }
        
        print(videoOrientation)
        
        // Create and setup video feed view
        cameraFeedView = CameraFeedView(frame: view.bounds, session: session, videoOrientation: videoOrientation)
        setupVideoOutputView(cameraFeedView)
        cameraFeedSession?.startRunning()
      
    }
    
    func createUI(){
 
        stateView = StateView.init(frame: CGRect(x: 0,y: self.view.frame.height/32, width:self.view.frame.width/2, height: self.view.frame.height / 6))
        stateView?.center.x = self.view.frame.midX
        //stateView?.backgroundColor = .blue
        self.view.addSubview(stateView!)
        stateView?.killConnection = {
            self.quitCamera()
        
        }
    }
    



    func setupVideoOutputView(_ videoOutputView: UIView) {
        videoOutputView.translatesAutoresizingMaskIntoConstraints = false
        videoOutputView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(videoOutputView)
        NSLayoutConstraint.activate([
            videoOutputView.leftAnchor.constraint(equalTo: view.leftAnchor),
            videoOutputView.rightAnchor.constraint(equalTo: view.rightAnchor),
            videoOutputView.topAnchor.constraint(equalTo: view.topAnchor),
            videoOutputView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        createUI()
    }
    
    // Draw a box on screen. Must be called from main queue.
    var boxLayer = [CAShapeLayer]()
    func draw(rect: CGRect, color: CGColor) {
        let layer = CAShapeLayer()
        layer.opacity = 1
        layer.borderColor = color
        layer.borderWidth = 2.5
        layer.frame = rect
        boxLayer.append(layer)
        cameraFeedView.previewLayer.insertSublayer(layer, at: 1)
    }
    
    // Remove all drawn boxes. Must be called on main queue.
    func removeBoxes() {
        for layer in boxLayer {
            layer.removeFromSuperlayer()
        }
        boxLayer.removeAll()
    }
    
    typealias ColoredBoxGroup = (color: CGColor, boxes: [CGRect])
    
    // Draws groups of colored boxes.
    func show(boxGroups: [ColoredBoxGroup]) {
        DispatchQueue.main.async {
            let layer = self.cameraFeedView.previewLayer
            self.removeBoxes()
           
           
            for boxGroup in boxGroups {
                let color = boxGroup.color
                for box in boxGroup.boxes {
                    let rect = layer!.layerRectConverted(fromMetadataOutputRect: box.applying(self.visionToAVFTransform))
                    
                    self.draw(rect: rect, color: color)
                }
            }
        }
    }
}






extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
      // outputDelegate?.cameraViewController(self, didReceiveBuffer: sampleBuffer, orientation: .up)
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            do {
                try requestHandler.perform([request])
            } catch {
                print(error)
            }
            
        }
       // let visionHandler = VNImageRequestHandler(cmSampleBuffer: buffer, orientation: orientation, options: [:])
        //let humanBodyRequest = VNDetectHumanBodyPoseRequest(completionHandler: detectedBodyPose)
        //print(humanBodyRequest.results)
       // print("fokf")
//        DispatchQueue.main.async {
//            let stateMachine = self.gameManager.stateMachine
//            if stateMachine.currentState is GameManager.SetupCameraState {
//                // Once we received first buffer we are ready to proceed to the next state
//                stateMachine.enter(GameManager.DetectingBoardState.self)
//            }
//        }
    }
}

