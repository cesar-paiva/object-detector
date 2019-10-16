//
//  CaptureManager.swift
//  object-detector
//
//  Created by Cesar Paiva.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import Foundation
import AVKit

class CaptureManager {
    
    lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        return captureSession
    }()
    
    weak var videoBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    init() {
        
    }
    
    func startCaptureSession() -> AVCaptureVideoPreviewLayer? {
        if askForPermission() {
            guard let captureDevice = AVCaptureDevice.default(for: .video) else { return nil }
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
            } catch {
                print(error.localizedDescription)
                return nil
            }
            captureSession.startRunning()
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.setSampleBufferDelegate(videoBufferDelegate, queue: DispatchQueue(label: "cameraQueue"))
            captureSession.addOutput(videoDataOutput)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            return previewLayer
        }
        return nil
    }
    
    func askForPermission() -> Bool {
        var hasPermission = true
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            hasPermission = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                hasPermission = true
            }
        case .restricted, .denied:
            hasPermission = false
        }
        
        return hasPermission
    }
    
}
