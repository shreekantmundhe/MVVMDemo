//
//  TagSearchAPI.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 19/09/2022.
//

import Foundation

protocol TagSearchAPIServiceProtocol {
    func getTagList(photoID: String, completion: @escaping (_ success: Bool, _ results: TagSearchResponse?, _ error: TagSearchAPIResultError?) -> ())
}

enum TagSearchAPIResultError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

class TagSearchAPI: TagSearchAPIServiceProtocol {

  typealias TagSearchAPIDataCompletion = (Bool, TagSearchResponse?, TagSearchAPIResultError?) -> ()
  
  private let apiKey = "2258a13716a5125b8dae87a7d8f332a7"
  private let host = "api.flickr.com"
  private let path = "/services/rest/"
  private let searchMethod = "flickr.tags.getListPhoto"
  private let responseFormat = "json"
  private let disableJSONCallback = "1"
  
    func getTagList(photoID: String,completion: @escaping TagSearchAPIDataCompletion) {
    var urlBuilder = URLComponents()
    urlBuilder.scheme = "https"
    urlBuilder.host = host
    urlBuilder.path = path
    urlBuilder.queryItems = [
      URLQueryItem(name: "api_key", value: apiKey),
      URLQueryItem(name: "method", value: searchMethod),
      URLQueryItem(name: "photo_id", value: photoID),
      URLQueryItem(name: "format", value: responseFormat),
      URLQueryItem(name: "nojsoncallback", value: disableJSONCallback)
    ]
    
    let url = urlBuilder.url!
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      //execute completion handler on main thread
      DispatchQueue.main.async {
        guard error == nil else {
          print("Failed request from Flickr: \(error!.localizedDescription)")
            completion(false, nil, .failedRequest)
          return
        }

        guard let data = data else {
          print("No data returned from Flickr")
          completion(false, nil, .noData)
          return
        }

        guard let response = response as? HTTPURLResponse else {
          print("Unable to process Flickr response")
          completion(false, nil, .invalidResponse)
          return
        }

        guard response.statusCode == 200 else {
          print("Failure response from Tag: \(response.statusCode)")
          completion(false, nil, .failedRequest)
          return
        }
        
        do {
          let decoder = JSONDecoder()
          let searchData = try decoder.decode(TagSearchResponse.self, from: data)
          
          completion(true, searchData, nil)
        } catch {
            print("error: ", error)
        }
      }
    }.resume()
  }
}
