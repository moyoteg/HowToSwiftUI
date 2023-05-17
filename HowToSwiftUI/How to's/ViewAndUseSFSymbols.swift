//
//  ViewAndUseSFSymbols.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/16/23.
//

import SwiftUI

struct ViewAndUseSFSymbols: View {
    @State private var searchText = ""

    let names: [String] = {
        if let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
            let resourcePath = bundle.path(forResource: "symbol_search", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: resourcePath) {

            /// keys in `plist` are names of all available symbols
            print(plist)
            print(plist.allKeys)
            return plist.allKeys as! [String]
        }
        
        return []
    }().sorted()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                List {
                    ForEach(names.filter { searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { symbolName in
                        NavigationLink(destination: SymbolDetail(symbolName: symbolName)) {
                            HStack(spacing: 16) {
                                Image(systemName: symbolName)
                                    .font(.title)
                                Text(symbolName)
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    UIPasteboard.general.string = symbolName
                                }) {
                                    Image(systemName: "doc.on.doc.fill")
                                        .foregroundColor(.accentColor)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal, -16)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
            .navigationTitle("SF Symbols")
        }
    }
}


struct SymbolDetail: View {
    let symbolName: String
    
    @State private var color: Color = .accentColor
    @State private var size: CGFloat = 50
    @State private var weight: Font.Weight = .regular
    @State private var design: Font.Design = .default
    @State private var italic: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button(action: {
                    UIPasteboard.general.string = symbolName
                }) {
                    Image(systemName: symbolName)
                        .font(.system(size: size, weight: weight, design: design))
                        .italic(italic)
                        .foregroundColor(color)
                }
                .buttonStyle(BorderlessButtonStyle())
                VStack(alignment: .leading, spacing: 8) {

                    ColorPicker("Color", selection: $color)
                    Text("Size")
                    Slider(value: $size, in: 10...100)
                    Text("Weight")
                    Picker("Select a weight", selection: $weight) {
                        Text("Ultra Light").tag(Font.Weight.ultraLight)
                        Text("Thin").tag(Font.Weight.thin)
                        Text("Light").tag(Font.Weight.light)
                        Text("Regular").tag(Font.Weight.regular)
                        Text("Medium").tag(Font.Weight.medium)
                        Text("Semibold").tag(Font.Weight.semibold)
                        Text("Bold").tag(Font.Weight.bold)
                        Text("Heavy").tag(Font.Weight.heavy)
                        Text("Black").tag(Font.Weight.black)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("Design")
                    Picker("Select a design", selection: $design) {
                        Text("Default").tag(Font.Design.default)
                        Text("Serif").tag(Font.Design.serif)
                        Text("Monospaced").tag(Font.Design.monospaced)
                        Text("Rounded").tag(Font.Design.rounded)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Toggle(isOn: $italic) {
                        Text("Italic")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .padding(.vertical, 40)
        }
        .navigationTitle(symbolName)
        .toolbar {
            Button(action: {
                UIPasteboard.general.string = symbolName
            }) {
                
                Text("copy name")
                    .padding()
                
                Image(systemName: "doc.on.doc.fill")
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}


struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct ViewAndUseSFSymbols_Previews: PreviewProvider {
    static var previews: some View {
        ViewAndUseSFSymbols()
    }
}
