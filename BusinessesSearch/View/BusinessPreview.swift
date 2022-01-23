//
//  BusinessPreview.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/5/22.
//

import SwiftUI

struct BusinessPreview: View {
    let business: Businesses.Business
    let index: Int
    
    var body: some View {
        businessPreView
    }
    
    var businessPreView: some View {
        HStack {
            AsyncImageView(stringURL: business.image_url) {
                placeHolder
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(width: 130, height: 100)
            VStack(alignment:.leading, spacing: 4){
                Text("\(index + 1).\(business.name) ")
                    .font(.headline)
                HStack {
                    RatingView(rating: business.rating)
                    Text("\(business.review_count)")
                        .foregroundColor(.secondary)
                }
                BusinessDetailView.categoryView(category: business.categories[0].title)
                BusinessDetailView.phoneView(phone: business.display_phone)
            }
        }
    }
}

struct BusinessPreview_Previews: PreviewProvider {
    static let business: Businesses.Business = Demodata.business
    static let index = 1
    static var previews: some View {
        Group {
            BusinessPreview(business: business, index: index)
        }
    }
}
