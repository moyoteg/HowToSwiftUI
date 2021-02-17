//
//  PassGenericContent.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI

struct PassGenericViewContent: View {
    var body: some View {
        Passthrough {
            Text("passed content")
        }
    }
}

struct Passthrough<Content>: View where Content: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
    }

}
