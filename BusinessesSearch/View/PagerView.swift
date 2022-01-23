//
//  PagerView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/5/22.
//

import SwiftUI

struct PagerView<Data, Content>: View
where Data : RandomAccessCollection, Data.Element : Hashable, Content : View {
    // the source data to render, can be a range, an array, or any other collection of Hashable
    private let data: Data
    // the index currently displayed page
    @Binding var currentIndex: Int
    // maps data to page views
    private let content: (Data.Element) -> Content
    
    // keeps track of how much did user swipe left or right
    @GestureState private var translation: CGFloat = 0
    
    // the custom init is here to allow for @ViewBuilder for
    // defining content mapping
    init(_ data: Data,
         currentIndex: Binding<Int>,
         @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        _currentIndex = currentIndex
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            LazyHStack(spacing: 0) {
                // render all the content, making sure that each page fills
                // the entire PagerView
                ForEach(data, id: \.self) { elem in
                        content(elem)
                            .frame(width: geometry.size.width)
                    }
            }
            .frame(width: geometry.size.width, alignment: .leading)
            // the first offset determines which page is shown
            .offset(x: -CGFloat(currentIndex) * geometry.size.width)
            // the second offset translates the page based on swipe
            .offset(x: translation)
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in

                    let offset = value.translation.width / geometry.size.width * 1.25
                    let newIndex = (CGFloat(currentIndex) - offset).rounded()
                    withAnimation {
                    currentIndex = min(max(Int(newIndex), 0), data.count - 1)
                    }
                }
            )
        }
    }
}
