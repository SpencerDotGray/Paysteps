//
//  HomeView.swift
//  PaySteps
//
//  Created by Spencer Gray on 10/29/20.
//

import SwiftUI

struct HomeView: View {
    
    @State var stepCount: Int = 603
    @State var stepGoal: Int = 900
    @State var stepProgress: CGFloat = 0.65
    @State var stepProgressChange: CGFloat = 0.0
    
    let timer = Timer.publish(every: 0.025, on: .main, in: .common).autoconnect()

    
    var body: some View {
        
        ZStack {
        
            Color(red: 241/255, green: 243/255, blue: 248/255)
            
            VStack {
                ZStack {
                    VStack {
                        Text("\(stepCount)")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                        Text("\(stepProgress) remaining")
                            .font(.subheadline)
                            .fontWeight(.thin)
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 10)
                    }
                    ActivityRing(progress: self.$stepProgress)
                        .onReceive(timer) { _ in
                            
                            while self.stepProgress < self.stepProgressChange {
                                self.stepProgress.addProduct(0.01, 1)
                            }
                        }
                }
                Spacer()
                    .frame(height: 230)
            }
        }.onAppear {
            
            //self.stepProgressChange = CGFloat.random(in: 0.0...1.0)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
