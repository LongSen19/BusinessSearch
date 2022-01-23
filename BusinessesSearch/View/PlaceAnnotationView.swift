//
//  PlaceAnnotationView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/19/22.
//

import SwiftUI

struct PlaceAnnotationView: View {
    var index: Int
    @Binding var isSelected: Int
    var body: some View {
      VStack(spacing: 0) {
          Circle()
              .foregroundColor(isSelected == index ? .yellow: .red)
          .frame(width: 25, height: 25)
          .overlay(Text("\(index + 1)").foregroundColor(.white))
        Image(systemName: "arrowtriangle.down.fill")
          .font(.caption)
          .foregroundColor(isSelected == index ? .yellow: .red)
          .offset(x: 0, y: -5)
      }
    }
}

struct PlaceAnnotationView_Previews: PreviewProvider {
    static var index = 0
    static var previews: some View {
        PlaceAnnotationView(index: index, isSelected: .constant(0))
    }
}
