//
//  RatingView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/3/22.
//

import SwiftUI

struct RatingView: View {
    let rating: Float
    var fillStar: Int = 0
    var isHalf = false
    var whiteColor: Bool = false
    
    init(rating: Float) {
        self.rating = rating
        if rating != -1 {
            fillStar = Int(rating)
            if Float(fillStar) + 0.5 == rating {
                isHalf = true
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 5) {
                    starView
                    halfStarView
        }
    }
    
    var starView: some View {
        ForEach(1..<fillStar + 1, id:\.self) { _ in
                Image(systemName: "star.fill")
                .foregroundColor(.yellow.opacity(0.8))
        }
    }
    
    var halfStarView: some View {
        Group {
        if isHalf {
            Image(systemName: "star.lefthalf.fill")
                .foregroundColor(.yellow.opacity(0.8))
        }
    }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 4.5)
    }
}

