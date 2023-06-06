//
//  GridLastCellTakesFullWidth.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/27/23.
//
import SwiftUI

import SwiftUIComponents

// Usage
struct UseGridLastCellTakesFullWidth: View {
    let data = Array(1...11).map { Example_GridLastCellTakesFullWidth.MyData(id: $0, number: $0) }
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        GridLastCellTakesFullWidth(data: data, columns: columns, spacing: 8) { item in
            Text("\(item.number)")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

// Add this to get preview
struct Example_GridLastCellTakesFullWidth_Previews: PreviewProvider {
    static var previews: some View {
        UseGridLastCellTakesFullWidth()
    }
}
