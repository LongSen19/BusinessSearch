//
//  IconLabel.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/19/22.
//

import SwiftUI

struct SuggestionView: View {
    @EnvironmentObject var businessesSearch: BusinessesSearch
    @Binding var term: String
    @Binding var location: String
    @Binding var showSearchPageView: Bool
    @Binding var suggestionSearch: Bool
    
    var body: some View {
        VStack{
            HStack {
                iconAndLabelView(icon: "restaurant", label: "Restaurants")
                iconAndLabelView(icon: "food", label: "Food")
                iconAndLabelView(icon: "drink", label: "Drinks")
                iconAndLabelView(icon: "takeout", label: "Takeout")
            }
            HStack {
                iconAndLabelView(icon: "plumber", label: "Plumbers")
                iconAndLabelView(icon: "auto", label: "Auto Repair")
                iconAndLabelView(icon: "salon", label: "Salons")
                iconAndLabelView(icon: "mover", label: "Movers")
            }
        }
    }
    
    func iconAndLabelView(icon: String, label: String) -> some View{
        VStack {
            Image(icon)
                .resizable()
                .frame(width: 70, height: 70)
            Text(label)
                .font(.body)
        }.onTapGesture {
            withAnimation {
                term = label
                location = "Current Location"
                showSearchPageView = true
                suggestionSearch = true
            }
        }
    }
}

struct IconLabel_Previews: PreviewProvider {

    static var previews: some View {
        SuggestionView(term: .constant("Denver"), location: .constant("Current Location"),showSearchPageView: .constant(false), suggestionSearch: .constant(true))
    }
}
