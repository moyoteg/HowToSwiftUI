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
    ]
    
    var body: some View {
        VStack {
            NavigationView {
                FilteredList("How To",
                             list: howTos) { (howTo) in
                    NavigationLink(howTo.description,
                                   destination:
                                    howTo.view
                                    .navigationBarTitle("\(howTo.name)")
                    )
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
