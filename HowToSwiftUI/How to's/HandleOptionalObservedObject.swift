//
//  HandleOptionalObservedObject.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 7/14/21.
//

import SwiftUI
import SwiftUtilities

struct HandleOptionalObservedObject: View {
    
    class Object: ObservableObject {
        @Published var optionalVar: Bool? {
            didSet {
                print("changed: \(String(describing: optionalVar))")
            }
        }
    }
    
    @ObservedObject var observedObject = Object()
    
    @State var makeOptionalVarNil = true {
        didSet {
            observedObject.optionalVar = makeOptionalVarNil ? nil:true
        }
    }
    
    var body: some View {
        VStack {
            Button("optional var is: \(String(describing: observedObject.optionalVar))") {
                makeOptionalVarNil.toggle()
            }
            Toggle("hi", isOn: Binding($observedObject.optionalVar) ?? .constant(false))
                .padding()
        }
    }
}

struct HandleOptionalObservedObject_Previews: PreviewProvider {
    static var previews: some View {
        HandleOptionalObservedObject()
    }
}
