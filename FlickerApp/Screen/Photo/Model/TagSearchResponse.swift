//
//  TagSearchResponse.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 20/09/2022.
//

import Foundation

struct TagSearchResponse: Codable {
    let photo : Photo?
    let stat: String?
}

struct Photo: Codable {
    let id: String?
    let tags : Tags?
}

struct Tags: Codable {
    let tag : [Tag]?
}

struct Tag: Codable {
    let id: String?
    let author: String?
    let authorname: String?
    let raw: String?
    let _content: String?
    let machine_tag: Bool?
}
