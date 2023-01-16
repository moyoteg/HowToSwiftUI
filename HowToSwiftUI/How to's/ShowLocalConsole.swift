//
//  ShowLocalConsole.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 1/16/23.
//

import SwiftUI

import CloudyLogs

struct ShowLocalConsole: View {
    
    @State var showConsole = false

    public var body: some View {
        
        Button("show console: \(showConsole.description)") {
            withAnimation {
                showConsole.toggle()
            }
        }
        .padding()
        
        Button("add log") {

            Logger.log("\(Int.random(in: 0..<999))")

        }
        .padding()
        
        Text("root")
            .localConsole(presented: showConsole)
        
            .onAppear {
                Logger.shared.logToLocalConsole = true
            }
    }
}

struct ShowLocalConsole_Previews: PreviewProvider {
    static var previews: some View {
        ShowLocalConsole()
    }
}
