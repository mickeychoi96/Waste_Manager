//
//  CameraViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/6/23.
//

import UIKit

class CameraViewController: UIViewController {

    let cameraView = CameraView()
    
    let modelHandler = ModelHandler()
    
    public var UserImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(cameraView)
        
        cameraView.resultImage.image = UserImage
        
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        predictionRequest()
    }
    
    func predictionRequest() {
        guard let ciimageResult = CIImage(image: UserImage!) else {
            fatalError("Can't convert UIImage")
        }
        
        cameraView.postDetail.text = modelHandler.detect(image: ciimageResult)
    }
    
}
