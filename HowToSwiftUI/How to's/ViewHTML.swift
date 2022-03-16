//
//  ViewHTML.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 3/14/22.
//

import SwiftUI

import SwiftUIComponents

struct ViewHTML: View {
    var body: some View {
        HTMLView(htmlText:
                        .constant(
                    """
                    <html>
                    <body>
                    <h1>
                    Hello World
                    </h1>
                    </body>
                    </html>
                    """
                        )
        )
    }
}

struct ViewHTML_Previews: PreviewProvider {
    static var previews: some View {
        ViewHTML()
    }
}
