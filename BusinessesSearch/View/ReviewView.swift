//
//  ReviewView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/14/22.
//

import SwiftUI

struct ReviewView: View {
    @StateObject var businessReviews: BusinessReviews
    var body: some View {
        ForEach(businessReviews.reviews) { review in
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                AsyncImageView(stringURL: review.user.image_url) {
                    placeHolder
                }
                .frame(width:60, height: 60)
                .clipShape(Circle())
                VStack {
                    Text(review.user.name ?? "")
                        .font(.headline)
                    Text(review.time_created.prefix(10))
                        .foregroundColor(.secondary)
                }
            }
            RatingView(rating: review.rating)
            Text(review.text)
            if review != businessReviews.reviews.last {
                Divider()
            }
        }
        .padding()
        }
        .listStyle(.plain)
    }
}

struct ReviewView_Previews: PreviewProvider {
    static let businessReviews = BusinessReviews(businessID: "8OuDGeV4Ru_VjbQIa_2w7A")
    static var previews: some View {
        ReviewView(businessReviews: businessReviews)
    }
}
