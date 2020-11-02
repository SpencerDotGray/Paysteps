//
//  ActivityRing.swift
//  PaySteps
//
//  Created by Spencer Gray on 10/29/20.
//

import SwiftUI

struct ActivityRing: View {
    
    @Binding var progress: CGFloat
    
    var dark: Color = Color(red: 154/255, green: 179/255, blue: 245/255)
    var light: Color = Color(red: 185/255, green: 255/255, blue: 252/255)
    var borderColor: Color = Color(red: 163/255, green: 216/255, blue: 244/255)
    var backgroundColor: Color = Color(red: 241/255, green: 243/255, blue: 248/255)
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(Color(red: 134/255, green: 196/255, blue: 186/255), lineWidth: 42)
                .frame(height: 250)
                
            if self.progress >= 1.0 || self.progress <= 0.0 {
                Circle()
                    .stroke(light, style: StrokeStyle(lineWidth: 45, lineCap: .round))
                    .frame(height: 250)
            } else {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(AngularGradient(gradient: Gradient(colors: [dark, light]), center: .center, startAngle: .degrees(0), endAngle: .degrees(360)), style: StrokeStyle(lineWidth: 45, lineCap: .butt))
                    .frame(height: 250)
            }
            
        }.frame(idealWidth: 300, idealHeight: 300, alignment: .center)
        .rotationEffect(.degrees(180))
    }
}
