//
//  ContentView.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/1/21.
//

import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    
    let howTos = [
        HowTo(isResolved: true, " 🔬 👨‍💻 sandbox 👩‍💻 🧪", AnyView(SandBox())),
        HowTo(isResolved: true, "hide nav bar", AnyView(HideNavigationBar())),
        HowTo(isResolved: true, "use sheet", AnyView(UseSheet())),
        HowTo(isResolved: true, "center text textfield", AnyView(CenterTextFieldPlaceholderText())),
        HowTo(isResolved: true, "insert and remove tab", AnyView(InsertAndRemoveTab())),
        HowTo(isResolved: true, "secure toggle textfield", AnyView(SecureToggleTextField())),
        HowTo(isResolved: false, "disable tab", AnyView(DisableTab())),
        HowTo(isResolved: true, "insert view w/ transition", AnyView(InsertViewWithTransition())),
        HowTo(isResolved: true, "show pop up", AnyView(ShowPopUP())),
        HowTo(isResolved: true, "pass generic content", AnyView(PassGenericViewContent())),
        HowTo(isResolved: true, "rotate 3D effect", AnyView(Rotate3DEffect())),
        HowTo(isResolved: true, "scroll rotating cards", AnyView(ScrollRotatingCards())),
        HowTo(isResolved: true, "reflect view", AnyView(ReflectView())),
        HowTo(isResolved: true, "curl page", AnyView(CurlPage())),
        HowTo(isResolved: false, "z stack images", AnyView(ZStackImages())),
        HowTo(isResolved: true, "use uikit page view", AnyView(UseUIKitPageView())),
        HowTo(isResolved: true, "use Lazy Grid", AnyView(UseLazyGrid())),
        HowTo(isResolved: true, "use image as view background", AnyView(UseImageAsViewBackground())),
        HowTo(isResolved: true, "show map annotations", AnyView(ShowMapAnnotations())),
        HowTo(isResolved: true, "track annotation in map", AnyView(TrackAnnotationInMap())),
        HowTo(isResolved: true, "handle optional observed object", AnyView(HandleOptionalObservedObject())),
        HowTo(isResolved: true, "update annotation location", AnyView(UpdateAnnotationLocation())),
        HowTo(isResolved: true, "copy text", AnyView(CopyText())),
        HowTo(isResolved: true, "add annotations to map", AnyView(AddAnnotationsToMap())),
        HowTo(isResolved: true, "space images proportionally", AnyView(SpaceImagesProportionally())),
        HowTo(isResolved: false, "size PDF image", AnyView(SizePDFImage())),
        HowTo(isResolved: true, "view HTML", AnyView(ViewHTML())),
        HowTo(isResolved: true, "show charts", AnyView(ShowCharts())),
        HowTo(isResolved: true, "Draw Border Around Rounded Rectangle", AnyView(DrawBorderAroundRoundedRectangle())),
        HowTo(isResolved: true, "Mask Rounded Rectangle As Percentange Pill", AnyView(MaskRoundedRectangleAsPercentangePill())),
        HowTo(isResolved: true, "Volumetric Pill", AnyView(VolumetricPill())),
        HowTo(isResolved: true, "Request All Permissions", AnyView(RequestAllPermissions())),
    ]
    
    var body: some View {
        VStack {
            NavigationView {
                FilteredList("How To",
                             list: howTos) { (howTo) in

                    NavigationLink(destination:
                                    howTo.view
                        .navigationBarTitle("\(howTo.name)")
                    ) {
                        HStack {
                            Text("\(howTo.description)")
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    
                }
            }
            .shadow(radius: 10)
            Divider()
            HStack {
                Text("✅ resolved")
                Divider()
                Text("❌ unresolved")
            }
            .fixedSize()    
            Divider()
            VStack {
                Text("by ") +
                    Text("Moi Gutiérrez")
                    .font(.system(size: 18, weight: .bold, design: .default)) +
                    Text(" with ❤️")
                Link("@moyoteg",
                     destination: URL(string: "https://www.twitter.com/moyoteg")!)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
