//
//  SearchPageView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/1/22.
//

import SwiftUI
import BottomSheet
import MapKit
import CoreLocationUI

struct SearchPageView: View {
    @EnvironmentObject var businessesSearch: BusinessesSearch
    @Binding var showSearchPageView: Bool
    @Binding var term: String
    @Binding var location: String
    @Binding var suggestionSearch: Bool
    @Binding var localIndex: Int
    @State private var bottomSheetPosition: BottomSheetPosition = .hidden
    @State private var listView: ListView = .historySearch
    @FocusState private var showKeyboard: Bool
    @State private var showMap: Bool = false
    @State private var showLocationTextField: Bool = true
    @State private var showAlert = false
    
    enum ListView {
        case historySearch
        case locationList
        case none
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                mainMapView
                VStack{
                    keywordSearchField
                    locationSearchField
                    customListView
                    Spacer()
//                    businessPagerView(in: geometry.size)
//                    if !businessesSearch.isFetching {
                        BusinessPagerView(businesses: businessesSearch.businesses, size: geometry.size, index: $businessesSearch.index)
                        .offset(x: 0, y: 130)
                        .opacity(bottomSheetPosition == .bottom ? 1 : 0)
                        .modifier(BottomSheetView(bottomSheetPosition: $bottomSheetPosition))
//                    }
                }
                .alert("Please provide key word and location to search", isPresented: $showAlert) {
                    Button("Ok", role: .cancel) {}
                }
            }.alert("No Results", isPresented: $businessesSearch.isEmpty) {
                Button("Ok", role: .cancel) {}
            }
        }
        .onAppear {
            if suggestionSearch {
                search()
                suggestionSearch = false
            }
            else {
                showKeyboard = true
            }
        }
    }
    
    var mainMapView: some View {
        Map(coordinateRegion: $businessesSearch.region, interactionModes: .all ,showsUserLocation: true,
            annotationItems: businessesSearch.businesses) { business in
            MapAnnotation(coordinate: business.coordinate) {
                PlaceAnnotationView(index: businessesSearch.businesses.index(matching: business), isSelected: $businessesSearch.index)
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        withAnimation {
                            bottomSheetPosition = .bottom
                            businessesSearch.index = businessesSearch.businesses.index(matching: business)
                        }
                    }
            }
        }
            .ignoresSafeArea()
            .tint(.pink)
            .opacity(showMap == true ? 1 : 0)
    }
    
    var keywordSearchField: some View {
        SearchFieldView(search: $term, text: "Search for Businesses", customImage: Image(systemName: "arrow.left")
                            .onTapGesture {
            withAnimation {
                showSearchPageView = false
                showMap = false
                localIndex = 0
            }
        })
            .onTapGesture {
                withAnimation {
                    self.listView = .historySearch
                    showLocationTextField = true
                }
            }
            .focused($showKeyboard)
            .onSubmit {
                search()
            }
    }
    
    var locationSearchField: some View {
        SearchFieldView(search: $location, text: "City, State, Zip Code", customImage: Image(systemName: "mappin.circle.fill"))
            .font(.footnote)
            .foregroundColor(location == "Current Location" ? .blue : .black)
            .onTapGesture {
                withAnimation {
                    listView = .locationList
                }
            }
            .onSubmit {
                search()
            }
            .opacity(showLocationTextField == true ? 1 : 0)
    }
    
//    func businessPagerView(in size: CGSize) -> some View {
//        PagerView(businessesSearch.businesses, currentIndex: $businessesSearch.index) { business in
//            HStack(spacing: 0) {
//                Image(systemName: "chevron.left")
//                    .frame(width: size.width * 0.05)
//                    .foregroundColor(.blue)
//                    .onTapGesture {
//                        withAnimation {
//                            businessesSearch.index -= 1
//                        }
//                    }
//                    .opacity(businessesSearch.index == 0 ? 0: 1)
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundColor(.white)
//                }
//                .frame(height: 130)
//                Image(systemName: "chevron.right")
//                    .frame(width: size.width * 0.05)
//                    .foregroundColor(.blue)
//                    .onTapGesture {
//                        withAnimation {
//                            businessesSearch.index += 1
//                        }
//                    }
//                    .opacity(businessesSearch.index == 19 ? 0 : 1)
//            }
//        }
//    }
        
    var customListView: some View {
        return Group {
            if listView == .historySearch {
                historySearchView
            } else if listView == .locationList {
                locationListView
            } else {
                EmptyView()
            }
        }
    }
        
    private func locationItemView(for text: String) -> some View{
        HStack(spacing: 12) {
            Image(systemName: "location")
                .foregroundColor(.black)
            Text(text)
                .font(.body)
            Spacer()
        }
    }
    
    var locationListView: some View {
        List {
            LocationButton(.currentLocation) {
                location = "Current Location"
                businessesSearch.fetchLocation()
            }
            .labelStyle(.titleAndIcon)
            .foregroundColor(.blue)
            .tint(.white)
            .offset(x: -8, y: 0)
            ForEach(businessesSearch.historyLocation, id:\.self) { location in
                locationItemView(for: location)
            }
        }
        .listStyle(.plain)
    }
    
    var historySearchView: some View {
        List(businessesSearch.historyKeywords, id:\.self) { keyword in
            HStack {
                Image(systemName: "timer")
                Text(keyword)
            }
        }
        .listStyle(.plain)
    }
    
    func search() {
        if term == "" || location == "" {
            showAlert = true
        }
        else {
            hideKeyboard()
            bottomSheetPosition = .middle
            listView = .none
            showMap = true
            showLocationTextField = false
            businessesSearch.fetchBusinesses(term: term, searchLocation: location)
        }
    }
}
//
//struct SearchPageView_Previews: PreviewProvider {
//    @State static var showSearchPageView: Bool = false
//    @State static var term = ""
//    @State static var location = ""
//    
//    static var previews: some View {
//        SearchPageView(showSearchPageView: $showSearchPageView,term: $term, location: $location)
//    }
//}
