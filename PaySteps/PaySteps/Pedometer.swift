//
//  Pedometer.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/4/20.
//

import Foundation
import CoreMotion

class Pedometer: ObservableObject {
    
    private let pedometer: CMPedometer = CMPedometer()
    private var steps: Int?
    private var distance: Double?
    private var startDate: Date?
    private var inUpdate: Bool = false
    private var w: Double = 195.0
    private var h: Double = 70.75
    
    @Published var hourSteps: [Double] = [Double](repeating: 0.0, count: 24)
    @Published var hourDist: [Double] = [Double](repeating: 0.0, count: 24)
    @Published var hourCal: [Double] = [Double](repeating: 0.0, count: 24)
    
    static let sharedInstance: Pedometer = {
        
        let instance = Pedometer()
        
        if CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable() {
            
            let startDate2 = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            
            instance.pedometer.queryPedometerData(from: startDate2 ?? Date(), to: Date()) { (data, error) in
                guard let data = data, error == nil else { return }
                
                instance.steps = data.numberOfSteps.intValue
                instance.distance = data.distance?.doubleValue
                instance.startDate = Date()
            }
        }
        
        return instance
    }()
    
    func getSteps() -> Int {
        
        return steps ?? 0
    }
    
    func getDistance() -> Double {
        
        return distance ?? 0.0
    }
    
    func getHourlySteps() {
        
        for i in 0..<hourSteps.count {
            
            let dateAtMidnight = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.startOfDay(for: Date())
            let curHour: Date = Calendar.current.date(byAdding: .hour, value: i, to: dateAtMidnight)!
            let nextHour: Date = Calendar.current.date(byAdding: .hour, value: 1, to: curHour)!
            
            self.pedometer.queryPedometerData(from: curHour, to: nextHour) { (data, error) in
                guard let data = data, error == nil else { return }
                
                print(data.numberOfSteps.doubleValue)
                self.hourSteps[i] = data.numberOfSteps.doubleValue
                self.hourCal[i] = (self.w*0.57)/(63360/(self.h*0.42))*self.hourSteps[i]
            }
        }

    }
    
    func getHourlyDistance() {
    
        
        for i in 0..<hourDist.count {
            
            let dateAtMidnight = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.startOfDay(for: Date())
            let curHour: Date = Calendar.current.date(byAdding: .hour, value: i, to: dateAtMidnight)!
            let nextHour: Date = Calendar.current.date(byAdding: .hour, value: 1, to: curHour)!
            
            if CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isStepCountingAvailable() {
                
                self.pedometer.queryPedometerData(from: curHour, to: nextHour) { (data, error) in
                    guard let data = data, error == nil else { return }
                    
                    let d = data.distance?.doubleValue ?? 0.0
                    self.hourDist[i] = d
                }
            }
        }
    
    }
    
    func update() {
        
        if !inUpdate {
        
            inUpdate.toggle()
            
            OperationQueue.main.addOperation{
                self.pedometer.startUpdates(from: NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.startOfDay(for: Date())){ (data, error) in
                    guard let data = data, error == nil else { return }
                    
                    self.steps = data.numberOfSteps.intValue
                    self.distance = data.distance?.doubleValue
                }
            }
            
            inUpdate.toggle()
        }
    }
}
