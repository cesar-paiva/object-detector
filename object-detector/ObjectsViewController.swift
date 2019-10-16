//
//  ObjectsViewController.swift
//  MeusOlhos
//
//  Created by Cesar Paiva
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ObjectsViewController: UIViewController {
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var labelIdentifier: UILabel!
    @IBOutlet weak var labelConfidence: UILabel!
    
    lazy var captureManager: CaptureManager = {
       let captureManager = CaptureManager()
        captureManager.videoBufferDelegate = self
        return captureManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelIdentifier.text?.removeAll()
        labelConfidence.text?.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let previewLayer = captureManager.startCaptureSession() else { return }
        previewLayer.frame = viewCamera.bounds
        viewCamera.layer.addSublayer(previewLayer)
    }
    
    @IBAction func analyse(_ sender: UIButton) {
        let word = labelIdentifier.text?.components(separatedBy: ",").first
        let text = "I am \(String(describing: labelConfidence.text)) confident that this is a \(String(describing: word))"
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
}

extension ObjectsViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: VGG16().model) else { return }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            for i in 0...5 {
                print(results[i].identifier, results[i].confidence)
            }
            print("=========================================")
            guard let firstObservation = results.first else { return }
            DispatchQueue.main.async {
                self.labelIdentifier.text = firstObservation.identifier
                let confidence = round(firstObservation.confidence * 1000) / 100
                self.labelConfidence.text = "\(confidence)%"
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
}
