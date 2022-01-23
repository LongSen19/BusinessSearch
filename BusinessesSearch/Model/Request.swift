//
//  Request.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/17/22.
//

import Foundation

struct Request {
    
    static let apiKey = "xFvjWTjrtfmEVWqqIpn-xbJerOUnrAOzsbm1WHpOHlHlAMmk_iMafif_FdZvzwD4WIYLFCTNAEYTG2kC7Uisa7WD44SkDOcw7sobxdsNH2T7GGrMTwSuIn8YifLMYXYx"
    
    static func createBusinessesURL(term: String, latitude: String, longitude: String) -> String {
        "https://api.yelp.com/v3/businesses/search?term=\(term)&latitude=\(latitude)&longitude=\(longitude)"
    }
    
    static func createBusinessesURL(term: String, location: String) -> String {
        "https://api.yelp.com/v3/businesses/search?term=\(term)&location=\(location)"
    }
    
    static func createBusinessDetailRequest(id: String) -> String {
        "https://api.yelp.com/v3/businesses/\(id)"
    }
    
    static func createReviewsURL(id: String) -> String {
        "https://api.yelp.com/v3/businesses/\(id)/reviews"
    }
    
    static func createRequest(with url: String) -> URLRequest {
        let url = URL(string: url)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}
