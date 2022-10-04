//
//  UseFilteredList.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 10/1/22.
//

import SwiftUI

import SwiftUIComponents

struct SelectListToShow: View {
    
    enum Lists: String, CaseIterable, Identifiable {
        
        var id: String { self.rawValue }
        
        case symbol
        case symbol2
    }
    
    @State var listSelection: Lists = .symbol

    var symbols = ["car", "pencil", "bus", "star", "waveform.path.ecg.rectangle"]

    var symbols2 = ["waveform.path.ecg.rectangle", "pencil", "star"]

    private var listToPresent: [String] {
        switch listSelection {
        case .symbol:
            return symbols
        case .symbol2:
            return symbols2
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                    Picker(
                        selection: $listSelection,
                        label: Text("List")
                    ) {
                        ForEach(Lists.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                
                
                GeometryReader { geometry in
                    
                    FilteredList("Symbols",
                                 list: listToPresent) { (string) in
                        
                        Text("\(string)")
                    }
                }
            }
            
        }
        .listStyle(GroupedListStyle())
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SelectListToShow_Previews: PreviewProvider {
    static var previews: some View {
        SelectListToShow()
    }
}
