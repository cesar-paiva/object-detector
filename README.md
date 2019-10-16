# Object Detector

### Description

iOS app that detects objects through the camera using machine learning. This app utilizes Apple's CoreML and Vision frameworks. 
 - The Vision framework performs face and face landmark detection, text detection, barcode recognition, image registration, and general feature tracking. Vision also allows the use of custom Core ML models for tasks like classification or object detection. 
 - Core ML integrates machine learning models into your application. Core ML provides a unified representation for all models. Your app uses core ML APIs and user data to forecast and train or tune models, all on the user's device.
 
## Requirements
- Xcode 10.2.1
- iOS 11
- Swift 4.2

## Getting Started

**Using Terminal:**
1. `git clone https://github.com/cesar-paiva/object-detector.git`
2. Download the 'VGG16.mlmodel' file from the Apple website at the link: https://docs-assets.developer.apple.com/coreml/models/VGG16.mlmodel and place it in the project root folder.
2. `cd object-detector`
