//
//  CryptoView.swift
//  PaySteps
//
//  Created by Spencer Gray on 12/4/20.
//

import SwiftUI

struct CryptoView: View {
    
    @ObservedObject var vm: DataView = DataView.sharedInstance
    
    var body: some View {
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CryptoView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoView()
    }
}
