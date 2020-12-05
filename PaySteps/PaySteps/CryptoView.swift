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
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                HStack {
                    Text("\(title)")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 10)
                    Spacer()
                    Text("\(cost)")
                    Spacer()
                        .frame(width: 10)
                }.frame(width: 280)
            }.background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1)
                    .background(Color(red: 163/255, green: 216/255, blue: 244/255))
                    .frame(width: 300)
                    
            )
            
            HStack {
                
                Text("\(description)")
                    .font(.body)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 280)
            .padding(.vertical, 20.0)
        }.background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 2)
                .background(Color.white)
                .frame(width: 300)
                
        ).onTapGesture {
            
            if let user = DataView.sharedInstance.currentUser {
                
                if user["balance"] as! Int >= cost {
                    DataView.sharedInstance.changeBalance(amount: -1*cost)
                }
            }
        }
    }
}

struct CryptoView: View {
    
    @ObservedObject var vm: DataView = DataView.sharedInstance
    
    var body: some View {
        
        ZStack {
            Color(red: 241/255, green: 243/255, blue: 248/255)
            VStack {
                
                HStack {
                    Spacer()
                        .frame(width: 10)
                    if vm.currentUser != nil {
                        
                        Text("Balance:")
                            .font(.title)
                            .fontWeight(.heavy)
                            .padding(.vertical, 10)
                        Text("\(vm.currentUser!["balance"] as! Int)")
                            .font(.title)
                            .fontWeight(.light)
                            .padding(.vertical, 10)
                    } else {
                        Text("Balance not available")
                            .font(.title)
                            .fontWeight(.heavy)
                            .padding(.vertical, 10)
                    }
                    Spacer()
                }.background(Color(red: 154/255, green: 179/255, blue: 245/255))
                
                
                ScrollView {
                    LazyVStack {
                        
                        ForEach(vm.activePromotions, id: \.title) { promotion in
                            
                            Spacer()
                                .frame(height: 10)
                            HStack {
                                Spacer()
                                PromotionCard(title: promotion.title, description: promotion.description, cost: promotion.cost)
                                Spacer()
                            }
                            Spacer()
                                .frame(height: 10)
                        }
                    }
                    
                }.background(Color(red: 241/255, green: 243/255, blue: 248/255))
                
            }
        }
    }
}

struct CryptoView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoView()
    }
}
