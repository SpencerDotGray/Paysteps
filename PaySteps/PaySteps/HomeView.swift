//
//  HomeView.swift
//  PaySteps
//
//  Created by Spencer Gray on 10/29/20.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var vm: DataView = DataView.sharedInstance
    @State var stepCount: Int = 0
    @State var stepFlag: Int = 0
    @State var stepGoal: Int = 10000
    @State var stepProgress: CGFloat = 0.0
    @State var stepProgressChange: CGFloat = 0.0
    @State var caloriesBurned: Float = 0.0
    @State var distanceTraveled: Float = 0.0
    @State var minutesMoving: Float = 0.0
    @State var pedometer: Pedometer = Pedometer.sharedInstance
    
    let timer = Timer.publish(every: 0.025, on: .main, in: .common).autoconnect()
    let pedoTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    
    var body: some View {
        
        GeometryReader { metrics in
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
                                    self.stepProgress = CGFloat(Double(self.stepCount) / Double(self.stepGoal))
                                    
                                    if self.stepCount > self.stepFlag {
                                        sendNotification(title: "Poggers")
                                        self.stepFlag += 100
                                    }
                                }
                            Text("\(self.stepGoal - self.stepCount) steps remaining")
                                .font(.subheadline)
                                .fontWeight(.thin)
                                .multilineTextAlignment(.center)
                            Spacer()
                                .frame(height: 10)
                        }
                        ActivityRing(progress: self.$stepProgress, radius: metrics.size.width * 0.75)
                            .onReceive(timer) { _ in

                                while self.stepProgress < self.stepProgressChange {
                                    self.stepProgress.addProduct(0.01, 1)
                                }
                            }
                    }
                    Spacer()
                        .frame(height: 150)
    //                Text("Calories: Coming Soon")
    //                Text("Mileage: Coming Soon")
    //                Text("Time Moving: Coming Soon")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
