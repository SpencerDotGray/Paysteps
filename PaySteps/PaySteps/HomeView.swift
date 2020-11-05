//
//  HomeView.swift
//  PaySteps
//
//  Created by Spencer Gray on 10/29/20.
//

import SwiftUI

struct HomeView: View {
    
    @State var stepCount: Int = 603
    @State var stepFlag: Int = 0
    @State var stepGoal: Int = 900
    @State var stepProgress: CGFloat = 0.65
    @State var stepProgressChange: CGFloat = 0.0
    @State var caloriesBurned: Float = 0.0
    @State var distanceTraveled: Float = 0.0
    @State var minutesMoving: Float = 0.0
    @State var pedometer: Pedometer = Pedometer.sharedInstance
    
    let timer = Timer.publish(every: 0.025, on: .main, in: .common).autoconnect()
    let pedoTimer = Timer.publish(every: 0.025, on: .main, in: .common).autoconnect()

    
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
                            .onReceive(pedoTimer) { _ in
                                pedometer.update()
                                self.stepCount = pedometer.getSteps()
                                
                                if self.stepCount > self.stepFlag {
                                    sendNotification(title: "Poggers")
                                    self.stepFlag += 100
                                }
                            }
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
                    .frame(height: 100)
                Text("Calories: \(caloriesBurned)")
                Text("Mileage: \(distanceTraveled)")
                Text("Time Moving: \(minutesMoving)")
                Spacer()
                    .frame(height: 70)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
