//
//  ClassificationResult.swift
//  CoreMLClassifier
//
//  Created by Lexter Tapawan on 2/25/26.
//

import Foundation

// MARK: - Result Model

struct ClassificationResult: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    
    var confidencePercent: String {
        String(format: "%>1.f%%", confidence * 100)
    }
}
