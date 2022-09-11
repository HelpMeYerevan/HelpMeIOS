//
//  PreviewView.swift
//  help.me
//
//  Created by Karen Galoyan on 11/16/21.
//

import UIKit
import AVFoundation

public final class PreviewView: UIView {
    
    // MARK: Properties
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    public override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
