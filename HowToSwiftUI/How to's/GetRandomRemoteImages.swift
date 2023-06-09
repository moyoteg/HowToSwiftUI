//
//  GetRandomRemoteImages.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 6/8/23.
//

import SwiftUI

import SwiftUIComponents

enum ImageSize {
    case small
    case medium
    case large
    
    func fetchImagesFromPicsum(count: Int) -> [URL] {
        var imageURLs = [URL]()
        
        let size: String
        
        switch self {
        case .small:
            size = "200/300"
        case .medium:
            size = "400/600"
        case .large:
            size = "800/1200"
        }
        
        for number in 1...count {
            let imageUrlString = "https://picsum.photos/id/\(number)/\(size)"
            if let imageUrl = URL(string: imageUrlString) {
                imageURLs.append(imageUrl)
            }
        }
        
        return imageURLs
    }
}

struct ImageView: View {
    let imageUrls: [URL]
    
    var body: some View {
        
        ForEach(imageUrls, id: \.self) { imageUrl in
            
            VStack {
                
                Text(imageUrl.absoluteString)
                    .textSelection(.enabled)
                
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "exclamationmark.icloud")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }
}

class PicsumImageURLGenerator: ObservableObject {
    
    enum ImageSize {
        case custom(width: Int, height: Int)
        case small
        case medium
        case large
        
        var urlComponent: String {
            switch self {
            case .custom(let width, let height):
                return "\(width)/\(height)"
            case .small:
                return "200/300"
            case .medium:
                return "400/600"
            case .large:
                return "800/1200"
            }
        }
    }
    
    enum ImageStyle: String, CaseIterable {
        case normal
        case grayscale
        case blurred
        
        var urlComponent: String {
            switch self {
            case .normal:
                return ""
            case .grayscale:
                return "grayscale"
            case .blurred:
                return "blur"
            }
        }
    }
    
    @Published var width: Int = 300
    @Published var height: Int = 300
    @Published var includeStyle: Bool = false
    @Published var includeSeed: Bool = false
    @Published var includeRedirectUrl: Bool = false
    @Published var includeAuthorId: Bool = false
    @Published var includeGravity: Bool = false
    @Published var includeRandom: Bool = false
    @Published var includeBlur: Bool = false

    @Published var style: ImageStyle = .normal
    @Published var seed: Int = 0
    @Published var redirectUrl: String = ""
    @Published var authorId: Int = 0
    @Published var gravity: String = ""
    
    func generateURL() -> URL? {
        var urlString = "https://picsum.photos/"
        
        var components = URLComponents(string: urlString)

        var queryItems: [URLQueryItem] = []

        // Seed
        if includeSeed && seed >= 0 {
            urlString.append("seed/\(seed)/")
//            components?.path = "/seed/\(seed)"
        }
        
        // Redirect URL
        if includeRedirectUrl && !redirectUrl.isEmpty {
            if let encodedRedirectUrl = redirectUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                urlString.append("?url=\(encodedRedirectUrl)")
            }
        }
        
        // Author ID
        if includeAuthorId && authorId >= 0 {
            urlString.append("author/\(authorId)/")
//            components?.path = "/id/\(authorId)"
        }
        
        // Gravity
        if includeGravity && !gravity.isEmpty {
            queryItems.append(URLQueryItem(name: "gravity", value: gravity))
        }
        
        // Width and Height
        urlString.append("\(width)/\(height)/")
//        components?.path = "/\(width)/\(height)"

        // Style
        if includeStyle && style != .normal {
           urlString.append("?\(style.urlComponent)")
//            queryItems.append(URLQueryItem(name: "", value: style.urlComponent))

        }
        
//        components?.queryItems = queryItems.isEmpty ? nil : queryItems
//        return components?.url
        
        return URL(string: urlString)
        
        // to implement?
        /*
        
        var components = URLComponents(string: urlString)

        if includeAuthorId {
            components?.path = "/id/\(authorId)"
        }
        
        var queryItems: [URLQueryItem] = []
        
        if includeRandom {
            queryItems.append(URLQueryItem(name: "random", value: nil))
        }
        
        if includeSeed {
            queryItems.append(URLQueryItem(name: "seed", value: "\(seed)"))
        }
        
        if includeBlur {
            queryItems.append(URLQueryItem(name: "blur", value: nil))
        }
        
        // Category
        if includeCategory && !category.isEmpty {
            urlString.append("category/\(category)/")
        }

        components?.path = "/\(width)/\(height)"

        components?.queryItems = queryItems.isEmpty ? nil : queryItems
         */
    }
}

struct PicsumImageURLGeneratorView: View {
    @ObservedObject private var generator = PicsumImageURLGenerator()
    @State private var numberOfShakes = 0.0
    @State private var buttonColor = .blue

    @State var imageUrls = [URL]()
    
    var body: some View {
        Form {
            Section(header: Text("Size")) {
                Stepper(value: $generator.width, in: 100...1000, step: 100) {
                    Text("Width: \(generator.width)")
                }
                Stepper(value: $generator.height, in: 100...1000, step: 100) {
                    Text("Height: \(generator.height)")
                }
            }
            
            Section(header: Text("Options")) {
                Toggle("Style", isOn: $generator.includeStyle)
                Toggle("Seed", isOn: $generator.includeSeed)
//                Toggle("Redirect URL", isOn: $generator.includeRedirectUrl)
                Toggle("Author ID", isOn: $generator.includeAuthorId)
                Toggle("Gravity", isOn: $generator.includeGravity)
            }
            
            if generator.includeStyle {
                Section(header: Text("Style")) {
                    Picker(selection: $generator.style, label: Text("Image Style")) {
                        ForEach(PicsumImageURLGenerator.ImageStyle.allCases, id: \.self) { style in
                            Text("\(style.rawValue)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            
            if generator.includeSeed {
                Section(header: Text("Style")) {
                    Stepper(value: $generator.seed, in: 0...1000, step: 1) {
                        Text("Seed: \(generator.seed)")
                    }
                }
            }

            if generator.includeRedirectUrl {
                Section(header: Text("Redirect URL")) {
                    TextField("Redirect URL", text: $generator.redirectUrl)
                }
            }

            if generator.includeAuthorId {
                Section(header: Text("Author ID")) {
                    Stepper(value: $generator.authorId, in: 0...1000, step: 1) {
                        Text("Author ID: \(generator.authorId)")
                    }
                }
            }
            
            if generator.includeGravity {
                Section(header: Text("Gravity")) {
                    TextField("Gravity", text: $generator.gravity)
                }
            }
            
            ImageView(imageUrls: imageUrls)
        }
        .toolbar {
            Button(action: {
                
                // Generate the image URL
                if let newURL = generator.generateURL() {
                    withAnimation {
                        imageUrls.insert(newURL, at: 0)
                    }
                } else {
                    withAnimation(Animation.easeInOut(duration: 2)) {
                        numberOfShakes = 10
                    }
                }
                
            }) {
                Text("Generate URL")
            }
            .shake(with: numberOfShakes)

        }
    }
}

struct GetRandomRemoteImages: View {
    let count = 5
    let imageSize = ImageSize.medium
    
    var body: some View {
        PicsumImageURLGeneratorView()
    }
}

struct GetRandomRemoteImages_Previews: PreviewProvider {
    static var previews: some View {
        GetRandomRemoteImages()
    }
}
