//
//  UtilityExtensions.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/5/22.
//

import Foundation

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index {
        return firstIndex(where: { $0.id == element.id })!
    }
}
