//
//  PhotoListViewModel.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 19/09/2022.
//

import Foundation
class PhotoListViewModel: NSObject {
    private var PhotoSearchAPIServiceProtocol: PhotoSearchAPIServiceProtocol
    private var TagSearchAPIServiceProtocol: TagSearchAPIServiceProtocol

    var reloadTableView: (() -> Void)?
    
    var PhotoSearchResponse: [FlickrURLs]?
    var TagSearchResponse: String?
    
    //MARK: Communicating through clousure to perform MVVM
    var photoCellViewModel = [PhotoCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    init(PhotoSearchAPIServiceProtocol: PhotoSearchAPIServiceProtocol = PhotoSearchAPI(),
         TagSearchAPIServiceProtocol: TagSearchAPIServiceProtocol = TagSearchAPI()) {
        self.PhotoSearchAPIServiceProtocol = PhotoSearchAPIServiceProtocol
        self.TagSearchAPIServiceProtocol = TagSearchAPIServiceProtocol
    }

    func getPhotos(_ searchTearm: String) {
        PhotoSearchAPIServiceProtocol.getImageList(searchTearm) { success, model, error in
            if success, let response = model?.photos?.photo {
                self.fetchPhotoData(photos: response)
            } else {
                print(error!)
            }
        }
    }

    func fetchPhotoData(photos: [FlickrURLs]) {
        PhotoSearchResponse = photos // Cache
        var photoCellViewModel = [PhotoCellViewModel]()
        for photo in photos {
            photoCellViewModel.append(createCellModel(photos: photo))
        }
        self.photoCellViewModel = photoCellViewModel
    }

    func createCellModel(photos: FlickrURLs) -> PhotoCellViewModel {
        let photoID = photos.id ?? ""
        let photo = photos.url_m ?? ""
        let farm = photos.farm ?? 0
        let server = photos.server ?? ""
        let owner = photos.owner ?? ""
        
        return PhotoCellViewModel(photoID: photoID, photo: photo, farm: farm , server: server, owner: owner)
    }

    func getCellViewModel(at indexPath: IndexPath) -> PhotoCellViewModel {
        return photoCellViewModel[indexPath.row]
    }
    
    //MARK: for tag search make API call under group dispatch. Need to do work
//    func getSyncImage() {
//              let group = DispatchGroup()
//
//               // Tag block operation
//               let tagBlockOperation = BlockOperation()
//               tagBlockOperation.addExecutionBlock {
//                   self.getTags()
//               }
//
//               // Photo block operation
//               let photoBlockOperation = BlockOperation()
//               photoBlockOperation.addExecutionBlock {
//                   self.getPhotos(group)
//                  // group.leave()
//                }
//
//
//
//               // adding dependency
//               tagBlockOperation.addDependency(photoBlockOperation)
//
//               // creating the operation queue
//               let operationQueue = OperationQueue()
//               operationQueue.addOperation(tagBlockOperation)
//               operationQueue.addOperation(photoBlockOperation)
//    }
    //    func getTags() {
    //        var photoCellViewModel = [PhotoCellViewModel]()
    //        var tags: String?
    //        guard let photos = self.PhotoSearchResponse else {
    //            return
    //        }
    //
    //        for photo in photos {
    //            TagSearchAPIServiceProtocol.getTagList(photoID: photo.id ?? ""){ success, model, error in
    //             if success, let response = model?.photo?.tags?.tag {
    //                tags = self.fetchTagData(tags: response)
    //                photoCellViewModel.append(self.createCellModel(photos: photo, tags: tags ?? ""))
    //                } else {
    //                    print(error!)
    //                }
    //            }
    //
    //        }
    //     //        self.photoCellViewModel = photoCellViewModel
    //    }
    
    //    func fetchTagData(tags: [Tag]) -> String {
    //        for tag in tags {
    //            TagSearchResponse?.append(tag.raw ?? "")
    //        }
    //        return TagSearchResponse ?? ""
    //    }
}
