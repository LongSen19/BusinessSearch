//
//  BusinessDetailView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/6/22.
//

import SwiftUI
import MapKit

struct BusinessDetailView: View {
    @EnvironmentObject var businessSearch: BusinessesSearch
    var business: Businesses.Business
    @State var currentIndex = 0
    @Environment(\.presentationMode) var presentationMode

    @State var destination: CLLocation?
    @State var travelTime: Double?
    @State var distace: Double?

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack(alignment: .leading) {
                            imageViews
                                .frame(height: geometry.size.height * 0.4)
                            businessNameAndRating
                                .offset(x: 12, y: geometry.size.height * 0.15)
                        }
                        businessDescription
                        customeDivider(in: geometry.size.height * 0.03)
                        mapViewSection(in: geometry.size.height * 0.3)
                        customeDivider(in: geometry.size.height * 0.03)
                        Text("Reviews")
                            .font(.system(size: 20).bold())
                            .padding([.leading, .top])
                        HStack {
                            RatingView(rating: business.rating)
                            Text("\(business.review_count) reviews")
                        }
                        .padding([.leading, .bottom])
                        Divider()
                        ReviewView(businessReviews: BusinessReviews(businessID: business.id))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(business.name)
                .toolbar {
                    ToolbarItem(placement:.navigationBarLeading) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack(spacing: 1) {
                                Image(systemName: "chevron.left")
                                Text("Search")
                            }
                        }
                    }
                }
            }
        }
    }
    
    var businessDescription: some View {
        VStack(alignment:.leading, spacing: 4) {
            categoriesView
            HStack {
                Image(systemName: "location.north.circle")
                Text("\(business.location.city), \(business.location.state)")
            }
            BusinessDetailView.phoneView(phone: business.display_phone)
            transactionsView
        }
        .padding()
    }
    
    func mapViewSection(in height: CGFloat) -> some View {
        VStack{
            MapView(region: businessSearch.region, destination:  $businessSearch.destination, travelTime: $travelTime, distance: $distace)
                .opacity(businessSearch.destination == nil ? 0:1)
                .frame(height: height)
            VStack(alignment: .leading) {
            HStack {
                Image(systemName: "car")
                if travelTime != nil {
                    Text(convenienceTravelTime(time: travelTime!))
                }
                Spacer()
                if distace != nil {
                    Text(String(format: "%.2f mil", distace!))
                        .foregroundColor(.secondary)
                }
            }
            Text(business.address)
                    .font(.caption)
            }
            .padding()
        }
    }
    
    func customeDivider(in height: CGFloat) -> some View {
        Color.gray
            .opacity(0.3)
            .frame(height: height)
    }
    
    var transactionsView: some View {
        Group {
            if business.transactions?.count != 0 {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                    Text(business.transactionsString)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    var imageViews: some View {
        Group {
            if business.photos != nil {
                PagerView(business.photos!, currentIndex: $currentIndex) { photo in
                    AsyncImageView(stringURL: photo) {
                        placeHolder
                    }
                }
            }
        }
    }
    
    var businessNameAndRating: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(business.name)
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(.white)
            HStack {
                RatingView(rating: business.rating)
                Text("\(business.review_count)")
                    .foregroundColor(.white)
            }
        }
    }
    
    
    var categoriesView: some View {
        HStack {
            ForEach(business.categories, id: \.self) { category in
                BusinessDetailView.categoryView(category: category.title)
            }
        }
    }
}

//struct BusinessDetailView_Previews: PreviewProvider {
//    static let business: Businesses.Business = Demodata.business
//    static var previews: some View {
//        BusinessDetailView(business: business)
//    }
//}


extension BusinessDetailView {
    
    static func phoneView(phone: String) -> some View {
        HStack {
            Image(systemName: "phone")
            Text(phone)
        }
        .foregroundColor(.blue)
    }
    
    
    static func categoryView(category: String) -> some View {
        Text(" \(category) ")
            .font(.system(size: 12))
            .foregroundColor(.black)
            .overlay(RoundedRectangle(cornerRadius: 5).foregroundColor(.gray.opacity(0.3)))
        
    }
    
    func secondsToHoursMinutes(_ seconds: Double) -> (Int, Int) {
        return (Int(seconds) / 3600, (Int(seconds) % 3600) / 60)
    }
    
    func convenienceTravelTime(time: Double) -> String {
        let (hour, minutes) = secondsToHoursMinutes(time)
        if hour > 0 {
            return "\(hour) hour \(minutes) minutes drive"
        }
        return "\(minutes) minutes drive"
    }
    
}
