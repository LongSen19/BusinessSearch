//
//  AsyncImageView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/1/22.
//

import SwiftUI

struct AsyncImageView<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeHolder: Placeholder
    private var width: CGFloat = 130
    private var height: CGFloat = 100
    
    init(stringURL: String?, width: CGFloat? = nil, height: CGFloat? = nil, @ViewBuilder placeHolder: () -> Placeholder) {
        self.placeHolder = placeHolder()
        _loader = StateObject(wrappedValue: ImageLoader(stringURL: stringURL ?? nil))
        if let width = width {
            self.width = width
        }
        if let height = height {
            self.height = height
        }
    }
    
    var body: some View {
        content
            .onAppear {
               loader.load()
            }
    }
    
    private var content: some View {
        Group {
            if loader.loadingImage == true {
                ProgressView()
            }
            else if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeHolder
            }
        }
    }
}
