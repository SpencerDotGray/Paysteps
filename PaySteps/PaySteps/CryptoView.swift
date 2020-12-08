//
//  CryptoView.swift
//  PaySteps
//
//  Created by Spencer Gray on 12/4/20.
//

import SwiftUI

struct PromotionCard: View {
    
    var title: String
    var description: String
    var cost: Int
    var image: UIImage?
    var width: CGFloat
    
    var dark: Color = Color(red: 154/255, green: 179/255, blue: 245/255)
    var darker: Color = Color(red: 124/255, green: 159/255, blue: 225/255)
    var light: Color = Color(red: 185/255, green: 255/255, blue: 252/255)
    var borderColor: Color = Color(red: 163/255, green: 216/255, blue: 244/255)
    var backgroundColor: Color = Color(red: 241/255, green: 243/255, blue: 248/255)
    
    @State var showingAlert: Bool = false
    @State var expand: Bool = false
    
    @State var alertTitle: String = ""
    @State var alertDescription: String = ""
    
    var body: some View {
                
        VStack {
            
            HStack {
                
                if image != nil {
                    Spacer()
                        .frame(width: 10)
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                Spacer()
                VStack {
                    Text("\(title)")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                        .frame(height: 5)
                    Text("\(cost)")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }.frame(width: self.width).padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(gradient: Gradient(colors: [self.dark, self.darker]), startPoint: UnitPoint(x: 0.9, y: 0.9), endPoint: UnitPoint(x: 0.25, y: 0.25)))
            ).onTapGesture { self.expand.toggle() }
            
            if self.expand {
            
                VStack {
                    
                    Text("\(description)")
                        .frame(width: self.width - 20.0)
                    Divider()
                    Button(action: {
                        
                        if let user = DataView.sharedInstance.currentUser {
                            
                            if user["balance"] as! Int >= cost {
                                self.alertTitle = "Thank you!"
                                self.alertDescription = "Your purchase of \"\(title)\" has been processed and will be sent to your email shortly."
                                DataView.sharedInstance.changeBalance(amount: -1*cost)
                                self.showingAlert = true
                            } else {
                                self.showingAlert = true
                                self.alertTitle = "Insufficient Funds"
                                self.alertDescription = "You do not have enough cryptocurrency to get\n\(title)"
                            }
                        }
                        
                    }) {
                        Text("Get").frame(width: self.width)
                    }.frame(width: self.width)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(self.alertTitle), message: Text(self.alertDescription), dismissButton: .default(Text("Ok")))
                            }
                }.frame(width: self.width).padding(.vertical, 10)
                
            }
            
        }.background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white))
        )
    }
}

struct CryptoView: View {
    
    @ObservedObject var vm: DataView = DataView.sharedInstance
    
    var dark: Color = Color(red: 154/255, green: 179/255, blue: 245/255)
    var light: Color = Color(red: 185/255, green: 255/255, blue: 252/255)
    var borderColor: Color = Color(red: 163/255, green: 216/255, blue: 244/255)
    var backgroundColor: Color = Color(red: 241/255, green: 243/255, blue: 248/255)
    
    var body: some View {
        
        GeometryReader { metrics in
            ZStack {
                self.backgroundColor
                VStack {
                    
                    HStack {
                        Spacer()
                            .frame(width: 10)
                        if vm.currentUser != nil {
                            
                            Text("Balance:")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                            Text("\(vm.currentUser!["balance"] as! Int)")
                                .font(.title)
                                .fontWeight(.light)
                                .padding(.vertical, 10)
                        } else {
                            Text("Balance not available")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
//                            Button(action: { DataView.sharedInstance.loadPromotions() }) {
//                                Text("Load Promotions")
//                                    .padding(.vertical, 10)
//                            }
                        }
                        Spacer()
                            .frame(width: 10)
                    }.background(Rectangle().stroke(Color.gray, lineWidth: 1).background(self.light)
                                    .frame(width: metrics.size.width))
                    .frame(width: metrics.size.width)
                    
                    
                    ScrollView {
                        LazyVStack {
                            
                            ForEach(vm.activePromotions, id: \.title) { promotion in
                                
                                Spacer()
                                    .frame(height: 10)
                                HStack {
                                    Spacer()
                                    PromotionCard(title: promotion.title, description: promotion.description, cost: promotion.cost, image: promotion.image, width: metrics.size.width * 0.90)
                                    Spacer()
                                }
                                Spacer()
                                    .frame(height: 10)
                            }
                        }
                        
                    }.background(Color(red: 241/255, green: 243/255, blue: 248/255))
                    
                }.frame(width: metrics.size.width, height: metrics.size.height)
            }
        }
    }
}

struct CryptoView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoView()
    }
}
