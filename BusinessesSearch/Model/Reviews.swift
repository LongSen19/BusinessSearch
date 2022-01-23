//
//  Reviews.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/12/22.
//

import Foundation

struct Reviews: Codable {
    var reviews: [Review]
    
    struct Review: Codable, Identifiable, Hashable {
        let id: String
        let text: String
        let rating: Float
        let time_created: String
        let user: User
        
        struct User: Identifiable, Codable, Hashable {
            let id: String?
            let image_url: String?
            let name: String?
        }
    }
}

struct DemoReview {
    static let review: Reviews.Review = Reviews.Review(id: "UpYbPqx0QScveW6Qy76ufg", text: "Doesn't get better than a breakfast burrito from The Point Market! I pick up a burrito from here just about every Saturday and always take visitors here and...", rating: 5, time_created: "2021-09-30 11:57:06", user: Reviews.Review.User(id: "isJWgaz0Ud7BlCqWy305Ug", image_url: "https://s3-media3.fl.yelpcdn.com/photo/eMWNbFQqVFCRxikr2B7GBA/o.jpg", name: "Marissa H."))
}
