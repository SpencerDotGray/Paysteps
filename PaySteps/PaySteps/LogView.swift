//
//  LogView.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/2/20.
//

import SwiftUI
import SwiftUICharts

struct ButtonView: View {
    
    @Binding var leftActive: Bool
    
    var body: some View {
        
        HStack {
            
            Button(action: { leftActive = true }, label: {
                    leftActive ?
                        Image(systemName: "square.grid.2x2.fill") :
                        Image(systemName: "square.grid.2x2")
            })
            Divider().frame(height: 20)
            Button(action: { leftActive = false }, label: {
                leftActive ?
                    Image(systemName: "rectangle.grid.1x2") :
                    Image(systemName: "rectangle.grid.1x2.fill")
        })
        }
        .padding(.vertical, 10.0)
        .padding(.horizontal, 15.0)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.blue, lineWidth: 1))
    }
}

struct DetailedView: View {
    
    var title: String
    var lineData: [Double]?
    @Binding var inDetailedView: Bool
    
    var body: some View {
        
        ZStack {
        
            LineView(data: lineData ?? [0], title: self.title)
        }.onAppear { self.inDetailedView = true }.onDisappear { self.inDetailedView = false }.padding(.horizontal, 10.0)
    }
}

struct LogView: View {
    
    @State var stepsPerHour: [Double] = Pedometer.sharedInstance.hourSteps
    @State var distancePerHour: [Double] = Pedometer.sharedInstance.hourDist
    @State var blankData: [Double] = [0.0, 1.0, 6.0, 2.0, 5.0, 1.0, 2.0, 6.0]
    @ObservedObject var pedometer: Pedometer = Pedometer.sharedInstance
    @State var displayGridView: Bool = true
    @State var inDetailedView: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Color(red: 241/255, green: 243/255, blue: 248/255)
        
            if displayGridView {
                NavigationView {
                    
                    ZStack {
                        Color(red: 241/255, green: 243/255, blue: 248/255)
                        VStack {
                            
                            HStack {
                                NavigationLink(destination: DetailedView(title: "Steps", lineData: pedometer.hourSteps, inDetailedView: $inDetailedView)) {
                                    LineChartView(data: pedometer.hourSteps, title: "Steps", form: ChartForm.small, dropShadow: false)
                                }
                                NavigationLink(destination: DetailedView(title: "Calories", lineData: blankData, inDetailedView: $inDetailedView)) {
                                    LineChartView(data: blankData, title: "Calories", form: ChartForm.small, dropShadow: false)
                                }
                            }
                            
                            HStack {
                                NavigationLink(destination: DetailedView(title: "Distance", lineData: pedometer.hourDist, inDetailedView: $inDetailedView)) {
                                    LineChartView(data: pedometer.hourDist, title: "Distance", form: ChartForm.small, dropShadow: false)
                                }
                                NavigationLink(destination: DetailedView(title: "Crypto", lineData: blankData, inDetailedView: $inDetailedView)) {
                                    LineChartView(data: blankData, title: "Crypto", form: ChartForm.small, dropShadow: false)
                                }
                            }
                        }
                    }
                }.navigationBarHidden(true)
            } else {
                NavigationView {
                
                    ScrollView {
                        NavigationLink(destination: DetailedView(title: "Steps", lineData: stepsPerHour, inDetailedView: $inDetailedView)) {
                            LineChartView(data: stepsPerHour, title: "Steps", form: ChartForm.large, dropShadow: false)
                        }
                        NavigationLink(destination: DetailedView(title: "Calories", lineData: blankData, inDetailedView: $inDetailedView)) {
                            LineChartView(data: blankData, title: "Calories", form: ChartForm.large, dropShadow: false)
                        }
                        NavigationLink(destination: DetailedView(title: "Distance", lineData: stepsPerHour, inDetailedView: $inDetailedView)) {
                            LineChartView(data: stepsPerHour, title: "Distance", form: ChartForm.large, dropShadow: false)
                        }
                        NavigationLink(destination: DetailedView(title: "Crypto", lineData: blankData, inDetailedView: $inDetailedView)) {
                            LineChartView(data: blankData, title: "Crypto", form: ChartForm.large, dropShadow: false)
                        }
                    }
                }.navigationBarHidden(true).navigationBarTitle("")
            }
            
            //if !inDetailedView {
                
            VStack {
                Spacer()
                    .frame(height: 20)
                ZStack {
//                        HStack {
//                            Spacer()
//                            ButtonView(leftActive: $displayGridView)
//                            Spacer()
//                                .frame(width: 10)
//                        }
                    HStack {
                        Spacer()
                        Text("Logs")
                            .font(.largeTitle)
                            .fontWeight(.thin)
                        Spacer()
                    }
                }
                Spacer()
            }
            //}
            
            
        }.onAppear {
            
            pedometer.getHourlySteps()
            pedometer.getHourlyDistance()
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
