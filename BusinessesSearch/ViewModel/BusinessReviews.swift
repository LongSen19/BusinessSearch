//
//  BusinessReviews.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/17/22.
//

import SwiftUI
import Combine

class BusinessReviews: ObservableObject {
    @Published var reviews: [Reviews.Review] = []
    private var autosaveCancellable: AnyCancellable?

    init(businessID: String) {
        let url = Request.createReviewsURL(id: businessID)
        let request = Request.createRequest(with: url)
        autosaveCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                print("output, ", output)
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: Reviews.self, decoder: JSONDecoder())
            .map(\.reviews)
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: \.reviews, on: self)        
    }
}
