//
//  CameraViewController.swift
//  UIKitSample
//
//  Created by skw on 2/21/25.
//

import IAssistKit
import UIKit
import AVFoundation

/// 카메라 샘플
class CameraViewController: IAViewController {
    // MARK: - Property
    @IBOutlet private weak var cameraView: CameraPreview!
    @IBOutlet private weak var captureImageView: UIImageView!
    
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action Func
    // 후면
    @IBAction func touchDualBack(_ sender: UIButton) {
        cameraView.setCamera(type: .builtInWideAngleCamera, position: .back)
    }
    
    // 전면
    @IBAction func touchDualFront(_ sender: UIButton) {
        cameraView.setCamera(type: .builtInWideAngleCamera, position: .front)
    }
    
    // 광각
    @IBAction func touchWideBack(_ sender: UIButton) {
        cameraView.setCamera(type: .builtInUltraWideCamera)
    }
    
    // 망원
    @IBAction func touchTelephoto(_ sender: UIButton) {
        cameraView.setCamera(type: .builtInTelephotoCamera)
    }
    
    // 촬영
    @IBAction func touchCapture(_ sender: UIButton) {
        cameraView.capture(delegate: self)
    }
    
    
    // MARK: - Private Func
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let photoData = photo.fileDataRepresentation() {
            let image = UIImage(data: photoData)
            Task {
                await MainActor.run {
                    captureImageView.image = image
                }
            }
            
            print("Captured Image: \(image!)")
        }
    }
}
