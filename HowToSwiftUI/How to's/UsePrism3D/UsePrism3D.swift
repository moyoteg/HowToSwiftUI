//
//  UsePrism.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/16/23.
//

import SwiftUI
import Prism

struct UsePrism3D: View {
    @StateObject var model = ViewModel()

    var body: some View {
        NavigationStack(path: $model.path) {
            ScrollView {
                VStack(spacing: 30) {
                    header

                    GalleryView(model: model)
                }
            }
            .background(UIColor.secondarySystemBackground.color)
        }
    }

    var header: some View {
        VStack(spacing: 20) {
            Text("Prism")
                .tracking(20)
                .offset(x: 10)
                .textCase(.uppercase)
                .font(.system(.largeTitle).weight(.ultraLight))

            HStack(spacing: 14) {
                ExampleLinkButton(title: "GitHub", url: "https://github.com/aheze/Prism")
                ExampleLinkButton(title: "Twitter", url: "https://twitter.com/aheze0")
            }
        }
        .padding(.top, 36)
    }
}

struct ExampleSliderView: View {
    var title: String
    @Binding var value: CGFloat
    var range: ClosedRange<CGFloat>
    var body: some View {
        GridRow {
            Text(title)
                .gridColumnAlignment(.leading)
                .padding(.vertical, 6)

            Slider(value: $value, in: range)
        }
    }
}

struct ExampleColorView: View {
    var title: String
    @Binding var value: Color
    var body: some View {
        GridRow {
            Text(title)
                .gridColumnAlignment(.leading)
                .padding(.vertical, 6)

            Color.clear
                .gridCellUnsizedAxes(.vertical)
                .overlay(alignment: .leading) {
                    ColorPicker(title, selection: $value)
                        .labelsHidden()
                }
        }
    }
}

struct ExampleLinkButton: View {
    var title: String
    var url: String

    var body: some View {
        Button {
            let url = URL(string: url)!
            UIApplication.shared.open(url)
        } label: {
            Text(title)
                .foregroundColor(.blue)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(.blue.opacity(0.1))
                .cornerRadius(12)
        }
    }
}
//    @State var configuration = PrismConfiguration(
//        tilt: 0.5, /// A value from 0 to 1, representing the perspective.
//        size: CGSize(width: 200, height: 200), /// How big the prism is.
//        extrusion: 100, /// The z height.
//        levitation: 20, /// How far the prism is from the ground.
//        shadowColor: Color.black, /// A dynamic shadow that's rendered underneath the prism.
//        shadowOpacity: 0.25 /// The strength of the shadow.
//    )
//
//    var body: some View {
//        PrismCanvas(tilt: configuration.tilt) {
//            PrismView(configuration: configuration) {
//                Color.blue
//            } left: {
//                Color.red
//            } right: {
//                Color.green
//            }
//        }
//    }
//}

//struct UsePrism: View {
//    @State var angle: Double = 0.0
//
//    var body: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//
//            Prism(angle: angle)
//                .fill(Color.purple)
//                .frame(width: 200, height: 200)
//                .rotation3DEffect(.degrees(angle), axis: (x: 1, y: 1, z: 0))
//                .animation(.linear(duration: 1))
//
//            Slider(value: $angle, in: 0...360)
//                .padding(.horizontal, 50)
//        }
//    }
//}

struct UsePrism_Previews: PreviewProvider {
    static var previews: some View {
        UsePrism3D()
    }
}
