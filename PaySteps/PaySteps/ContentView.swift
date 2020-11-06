//
//  ContentView.swift
//  PaySteps
//
//  Created by Spencer Gray on 10/29/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var sel: Int = 1
    
    var body: some View {
        
        TabView(selection: self.$sel) {
            LogView().tabItem { Image(systemName: "chart.bar.xaxis"); Text("Logs") }.tag(2)
            HomeView().tabItem { Image(systemName: "house.fill"); Text("Home") }.tag(1)
            Text("Coming Soon").tabItem { Image(systemName: "bitcoinsign.square.fill"); Text("Crypto") }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
