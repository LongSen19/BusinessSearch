//
//  Businesses.swift
//  BusinessesSearch
//
//  Created by Long Sen on 12/30/21.
//

import Foundation
import CoreLocation

struct Businesses: Codable {
    var businesses: [Business]
    
    struct Business: Codable, Identifiable, Hashable {
        
        let id: String
        let name: String
        let display_phone: String
        let review_count: Int
        let categories: [Category]
        let rating: Float
        let location: Location
        let coordinates: Coordinate
        let image_url: String
        let photos: [String]?
        let transactions: [String]?
        
        struct Category: Codable, Hashable {
            let alias: String
            let title: String
        }
        
        struct Location: Codable, Hashable {
            let city: String
            let state: String
            let display_address: [String]
        }
        
        struct Coordinate: Codable, Hashable {
            let latitude: Double
            let longitude: Double
        }
        
    }
}

struct Demodata {
    static let business: Businesses.Business = Businesses.Business(id: "gagUrh3806qc5hZ14F0Odw", name: "Denver Biscuit", display_phone: "(303) 377-7900", review_count: 4034, categories: [Businesses.Business.Category(alias: "sandwiches", title: "sandwiches"),Businesses.Business.Category(alias: "sandwiches", title: "vietnames"),Businesses.Business.Category(alias: "sandwiches", title: "noodle")], rating: 4.5, location: Businesses.Business.Location(city: "Denver", state: "CO",display_address: ["3237 E Colfax Ave","Denver, CO 80206"]), coordinates: Businesses.Business.Coordinate(latitude: 39.740384, longitude: -104.949098), image_url: "https://s3-media1.fl.yelpcdn.com/bphoto/bxPN9shgJEtwvT3Hrf_pCg/o.jpg", photos: ["https://s3-media1.fl.yelpcdn.com/bphoto/bxPN9shgJEtwvT3Hrf_pCg/o.jpg","https://s3-media1.fl.yelpcdn.com/bphoto/WgUIK8M236LzLjDQ5Idu6w/o.jpg","https://s3-media2.fl.yelpcdn.com/bphoto/sFG5Wuj_g-Msszto9dndmA/o.jpg"], transactions: ["Pick Up"])
    static let businesses: Businesses = Businesses.init(businesses: [business,business])
}

extension Businesses.Business {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    var address: String {
        location.display_address.joined(separator: ", ")
    }
    
    var transactionsString: String {
        if transactions != nil {
            return transactions!.joined(separator: ", ")
        }
        return ""
    }
}


