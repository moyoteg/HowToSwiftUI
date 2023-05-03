//
//  GenerateAcknowledgements.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/3/23.
//

import SwiftUI

import AckGen
import AckGenUI

struct GenerateAcknowledgements: View {
    
    let acknowledgements: [Acknowledgement] = Acknowledgement.all()

    var body: some View {
        NavigationView {
            AcknowledgementsList()
        }
    }
}

struct GenerateAcknowledgements_Previews: PreviewProvider {
    static var previews: some View {
        GenerateAcknowledgements()
    }
}
