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

@MainActor
class ClassifierViewModel: ObservableObject {   // class opens here
    
    // @Published properties
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
}
