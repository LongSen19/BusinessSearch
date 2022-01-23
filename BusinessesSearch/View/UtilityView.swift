//
//  UtilityView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/5/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
   
    var placeHolder: some View {
        ZStack {
            Color.white
            Text("No Image")
        }
    }
}

