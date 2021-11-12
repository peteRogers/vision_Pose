/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom views that are presenting video from different sources:
     CameraFeedView - displays video frames captured by the camera.
     VideoRenderView - displays video frames read from the prerecorded file.
*/

import UIKit
import AVFoundation

// MARK: - Coordinates conversion
//protocol NormalizedGeometryConverting {
//    func viewRectConverted(fromNormalizedContentsRect normalizedRect: CGRect) -> CGRect
//    func viewPointConverted(fromNormalizedContentsPoint normalizedPoint: CGPoint) -> CGPoint
//}

// MARK: - View to display live camera feed
class CameraFeedView: UIView {
   // class CameraFeedView: UIView, NormalizedGeometryConverting {
     var previewLayer: AVCaptureVideoPreviewLayer!
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    init(frame: CGRect, session: AVCaptureSession, videoOrientation: AVCaptureVideoOrientation) {
        super.init(frame: frame)
        previewLayer = layer as? AVCaptureVideoPreviewLayer
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspect
        previewLayer.connection?.videoOrientation = videoOrientation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func viewRectConverted(fromNormalizedContentsRect normalizedRect: CGRect) -> CGRect {
//        return previewLayer.layerRectConverted(fromMetadataOutputRect: normalizedRect)
//    }
//
//    func viewPointConverted(fromNormalizedContentsPoint normalizedPoint: CGPoint) -> CGPoint {
//        return previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
//    }
}

