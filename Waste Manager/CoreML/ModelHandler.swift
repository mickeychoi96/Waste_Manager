//
//  Prediction.swift
//  Waste Manager
//
//  Created by 최유현 on 11/29/23.
//

import Foundation
import CoreML
import UIKit
import Vision

class ModelHandler {
    
    private let model: VNCoreMLModel

    init() {
        do {
            let coreMLModel = try WasteManagerML_3(configuration: MLModelConfiguration())
            model = try VNCoreMLModel(for: coreMLModel.model)
        } catch {
            fatalError("Loading model failed")
        }
    }
    
    func detect(image: CIImage) -> String {
        var result = ""
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Lading request failed")
            }
            
            result = results.first?.identifier ?? "Default"
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        return result
    }
}
