//
//  PhotoSearchResponse.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 19/09/2022.
//

import Foundation

struct PhotoSearchResponse: Codable {
    let photos : FlickrPagedImageResult?
    let stat: String
}

struct FlickrPagedImageResult: Codable {
    let photo : [FlickrURLs]?
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
}

struct FlickrURLs: Codable {
    let id : String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
    let ispublic: Int?
    let isfriend: Int?
    let isfamily: Int?
    let url_m: String?
    let height_m: Int?
    let width_m: Int?
}
