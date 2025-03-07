//
//  CameraViewController.swift
//  UIKitSample
//
//  Created by skw on 2/21/25.
//

import IACoreKit
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
    
    @IBAction func touchTest(_ sender: UIButton) {
//        cameraView.adjustZoomFactor(5.0)
//        debugPrint("min \(cameraView.captureDevice.minAvailableVideoZoomFactor) max \(cameraView.captureDevice.maxAvailableVideoZoomFactor)")
        
        cameraView.adjustZoomFactor(123.0)
        // 물리적 줌 배율 계산하기 (렌즈 초점 거리 기준)
        do {
            try cameraView.captureDevice.lockForConfiguration()
            
            // 현재 초점 거리(focal length)와 최소 초점 거리
            let currentFocalLength = cameraView.captureDevice.lensPosition
            let minFocalLength = cameraView.captureDevice.minAvailableVideoZoomFactor
            let maxFocalLength = cameraView.captureDevice.maxAvailableVideoZoomFactor
            
            print("현재 초점 거리: \(currentFocalLength)")
            print("최소 초점 거리: \(minFocalLength)")
            print("최대 초점 거리: \(maxFocalLength)")

            cameraView.captureDevice.unlockForConfiguration()
        } catch {
            print("카메라 설정을 잠글 수 없습니다: \(error)")
        }
        
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
