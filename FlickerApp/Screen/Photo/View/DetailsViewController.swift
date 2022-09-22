//
//  DetailsViewController.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 20/09/2022.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController, PhotoInfoModelDelegate {

    @IBOutlet var imageTitle: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var discription: UILabel!
    @IBOutlet var photo: UIImageView!
    
    var photoID: String?
    lazy var viewModel = {
        PhotoDetailsResponseViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        guard let id = photoID else {
            return
        }
        viewModel.getPhotoInfo(id)
    }

    func didReceivePhotoInfoResponse(infoResponse: PhotoInfo?) {
        imageTitle.text = infoResponse?.title?._content
        
        date.text = infoResponse?.dates?.taken
        discription.text = infoResponse?.description?._content
        discription.numberOfLines = 0
        setPhoto(infoResponse)
    }
    
    func setPhoto(_ infoResponse: PhotoInfo?) {
        if let server = infoResponse?.server,
           let secretId = infoResponse?.secret,
           let id = infoResponse?.id,
           let url = URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secretId).jpg"){
            photo.load(url: url)
        }
    }
}
