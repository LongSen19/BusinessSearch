//
//  BusinessListView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/1/22.
//

import SwiftUI
import BottomSheet

struct BottomSheetView: ViewModifier {
    
    @Binding var bottomSheetPosition: BottomSheetPosition
    @State var searchText: String = ""
    @EnvironmentObject var businessesSearch: BusinessesSearch
    
    func body(content: Content) -> some View {
        VStack {
            content
                .edgesIgnoringSafeArea(.all)
                .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.noBottomPosition, .allowContentDrag]
                             ,headerContent: {
                    //A SearchBar as headerContent.
                    VStack {
                        Divider()
                            .padding(.trailing, -30)
                    }
                }
                ) {
                    BusinessListView(businesses: businessesSearch.businesses)
                }
        }
    }
}
