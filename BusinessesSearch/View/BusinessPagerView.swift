//
//  BusinessPagerView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/20/22.
//

import SwiftUI

struct BusinessPagerView: View {
    @EnvironmentObject var businessesSearch: BusinessesSearch
    var businesses: [Businesses.Business]
    let size: CGSize
    @Binding var index: Int
    
    var body: some View {
        PagerView(businesses, currentIndex: $index) { business in
            HStack(spacing: 0) {
                Image(systemName: "chevron.left")
                    .frame(width: size.width * 0.05)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        withAnimation {
                            index -= 1
                        }
                    }
                    .opacity(index == 0 ? 0: 1)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                    if !businessesSearch.isFetching {
                        BusinessPreview(business: business, index: businesses.index(matching: business))
                            .onTapGesture {
                                businessesSearch.fetchBusinessDetail(for: business.id)
                            }
                    }
                }
                .frame(height: 130)
                Image(systemName: "chevron.right")
                    .frame(width: size.width * 0.05)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        withAnimation {
                            index += 1
                        }
                    }
                    .opacity(index == businesses.count - 1 ? 0 : 1)
            }
        }
        .sheet(item: $businessesSearch.businessDetail, content: { business in
            BusinessDetailView(business: business)
        })
    }
}

//struct BusinessPagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BusinessPagerView(size: CGSize(width: .max, height: 100))
//    }
//}
