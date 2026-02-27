//
//  ClassifierViewModel.swift
//  CoreMLClassifier
//
//  Created by Lexter Tapawan on 2/25/26.
//

import SwiftUI
import Vision
import CoreML
import Combine

// MARK: - ViewModel

@MainActor
class ClassifierViewModel: ObservableObject {   // class opens here
    
    // MARK: - @Published properties
    @Published var results: [ClassificationResult] = []
    @Published var inferenceTime: Double = 0
    @Published var isClassifying: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedImage: UIImage? = nil
    
    // MARK: - Private Properties
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        guard let model = try? MobileNetV2(configuration: MLModelConfiguration()),
              let vnModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Failed to load CoreML model. Make sure MobileNetV2.mlpackage is added to the project.")
        }
        
        let request = VNCoreMLRequest(model: vnModel)
        request.imageCropAndScaleOption = .centerCrop
        
        return request
    }()
    
    // MARK: - Public API
    
    func classify(image: UIImage) {
        selectedImage = image
        results = []
        errorMessage = nil
        isClassifying = true
        
        let visionRequest = classificationRequest
        
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            
            guard let cgImage = image.cgImage else {
                await MainActor.run {
                    self.errorMessage = "Couldn't convert image."
                    self.isClassifying = false
                }
                return
            }
            
            let start = Date()
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([visionRequest])
            } catch {
                await MainActor.run {
                    self.errorMessage = "Inference failed: \(error.localizedDescription)"
                    self.isClassifying = false
                }
                return
            }
            
            let elapsed = Date().timeIntervalSince(start)
        }
    }
}
