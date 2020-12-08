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
    @Binding var goBack: Bool
    
    var body: some View {
        
        ZStack {
        
            VStack {
                LineView(data: lineData ?? [0], title: self.title)
            }
        }.padding(.horizontal, 10.0)
    }
}

struct LogView: View {
    
    @State var stepsPerHour: [Double] = Pedometer.sharedInstance.hourSteps
    @State var distancePerHour: [Double] = Pedometer.sharedInstance.hourDist
    @State var caloriesPerHour: [Double] = Pedometer.sharedInstance.hourCal
    @State var blankData: [Double] = [0.0, 1.0, 6.0, 2.0, 5.0, 1.0, 2.0, 6.0]
    @ObservedObject var pedometer: Pedometer = Pedometer.sharedInstance
    @State var showDetailedView: Bool = false
    @State var inDetailedView: Bool = false
    @State var detailedTitle: String = ""
    @State var detailedData: [Double] = []
    
    var body: some View {
        
        ZStack {
            
            Color(red: 241/255, green: 243/255, blue: 248/255)
        

            if showDetailedView {
               
                DetailedView(title: self.detailedTitle, lineData: self.detailedData, goBack: self.$showDetailedView)

            } else {
                
                NavigationView {
                    
                    LazyVStack {
                        NavigationLink(destination: DetailedView(title: "Steps", lineData: blankData, goBack: self.$showDetailedView)) {
                            LineChartView(data: stepsPerHour, title: "Steps", form: ChartForm.large, dropShadow: false)
                        }
                        NavigationLink(destination: DetailedView(title: "Distance", lineData: blankData, goBack: self.$showDetailedView)) {
                            LineChartView(data: blankData, title: "Distance", form: ChartForm.large, dropShadow: false)
                        }
                    }
                }.navigationBarTitle("Logs")
            }
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
