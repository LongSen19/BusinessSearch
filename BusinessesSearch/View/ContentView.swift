//
//  ContentView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 12/30/21.
//

import SwiftUI
import CoreData
import BottomSheet
import MapKit
import CoreLocationUI

struct ContentView: View {
    
    @EnvironmentObject var businessesSearch: BusinessesSearch
    @State private var showSearchPageView = false
    @State private var term = ""
    @State private var location = ""
    @State private var offset: Double = 0
    @State private var suggestionSearch = false
    
    var body: some View {
        return Group {
            if showSearchPageView {
                SearchPageView(showSearchPageView: $showSearchPageView, term: $term, location: $location, suggestionSearch: $suggestionSearch, localIndex: $index)
                    .transition(transition)
            }
            else {
                mainView
            }
        }
        .onAppear {
            businessesSearch.fetchLocation()
        }
    }
    
    var searchField: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12).foregroundColor(.white)
                .shadow(radius: 10)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
                    .frame(height:40)
                Text("Search for Businesses")
                    .foregroundColor(.secondary)
                    .frame(height:40)
                Spacer()
            }
            .padding([.leading])
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding()
        .onTapGesture {
            withAnimation {
                showSearchPageView = true
            }
        }
        
    }
    
    var mainView: some View {
        GeometryReader { geometry in
            VStack {
                Rectangle()
                    .overlay(Image("foodImage").resizable())
                    .ignoresSafeArea()
                    .frame(height: geometry.size.height * 0.35)
                VStack {
                    searchField
                    SuggestionView(term: $term, location: $location,showSearchPageView: $showSearchPageView, suggestionSearch: $suggestionSearch)
                    searchingHistoryView(in: geometry.size)
                }.offset(x: 0, y: -geometry.size.height * 0.05)
            }
        }
    }
    
    @State private var index = 0
    
    func searchingHistoryView(in size: CGSize) -> some View {
        Group {
            if businessesSearch.searchingHistoryBusinesses.count > 0 {
                VStack {
                    Divider()
                    Text("Searching History")
                        .font(.headline)
                    BusinessPagerView(businesses: businessesSearch.searchingHistoryBusinesses, size: size, index: $index)
                }
            }
        }
    }
    
    let transition = AnyTransition
        .offset(x: 0, y: 300)
}


struct ContentView_Previews: PreviewProvider {
    @StateObject static var businessesSearch = BusinessesSearch()
    static var previews: some View {
        ContentView()
            .environmentObject(businessesSearch)
    }
}
