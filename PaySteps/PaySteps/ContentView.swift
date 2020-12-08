//
//  ContentView.swift
//  PaySteps
//
//  Created by Spencer Gray on 10/29/20.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    
    @ObservedObject var vm: DataView = DataView.sharedInstance
    @State var sel: Int = 1
    
    var dark: Color = Color(red: 154/255, green: 179/255, blue: 245/255)
    var light: Color = Color(red: 185/255, green: 255/255, blue: 252/255)
    var borderColor: Color = Color(red: 163/255, green: 216/255, blue: 244/255)
    var backgroundColor: Color = Color(red: 241/255, green: 243/255, blue: 248/255)
    
    var body: some View {
        
        VStack {
            if vm.loginEmail != .valid || vm.verified != .valid {
                
                LoginView()
            } else {
            
                TabView(selection: self.$sel) {
                    LogView().tabItem { Image(systemName: "chart.bar.xaxis"); Text("Logs") }.tag(2)
                    HomeView().tabItem { Image(systemName: "house.fill"); Text("Home") }.tag(1)
                    CryptoView().tabItem { Image(systemName: "bag.fill"); Text("Promotions") }.tag(3)
                    AccountView().tabItem { Image(systemName: "person.crop.circle.fill"); Text("Account") }.tag(4)
                }.onAppear {
                    UITabBar.appearance().backgroundColor = UIColor(self.dark)
                }
            }
        }.onAppear {
            vm.loadNotifications()
            vm.loadPromotions()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
