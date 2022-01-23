//
//  BusinessListView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/1/22.
//

import SwiftUI

struct BusinessListView: View {
    @EnvironmentObject var businessesSearch: BusinessesSearch
    var businesses: [Businesses.Business]
    
    var body: some View {
        List(businessesSearch.businesses) { business in
            BusinessPreview(business: business, index: businessesSearch.businesses.index(matching: business))
                .onTapGesture {
                    businessesSearch.fetchBusinessDetail(for: business.id)
                }
        }
        .sheet(item: $businessesSearch.businessDetail, content: { business in
            BusinessDetailView(business: business)
        })
        .listStyle(.plain)
    }
}


struct BusinessListView_Previews: PreviewProvider {
    static let businesses = Demodata.businesses
    
    static var previews: some View {
        BusinessListView(businesses: businesses.businesses)
    }
}


