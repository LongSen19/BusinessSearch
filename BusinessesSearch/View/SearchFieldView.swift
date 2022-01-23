//
//  SearchFieldView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/1/22.
//

import SwiftUI

struct SearchFieldView<CustomImage: View>: View {
    @Binding var search: String
    var text: String
    var customImage: CustomImage

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
            HStack{
                customImage
                    .foregroundColor(.blue)
                    .padding([.leading])
                TextField(text, text: $search)
                    .frame(height: 40)
                    .submitLabel(.search)
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).foregroundColor(.secondary))
        .padding()
        .frame(height: 50)
    }
}

