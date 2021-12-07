//
//  Clock.swift
//  vision_Pose
//
//  Created by Peter Rogers on 07/12/2021.
//

import Foundation

class Clock {
    var cTime:Date
    var timer:Timer?
    var isFast = false
   

    init() {
        cTime = Date.now
        startTimer()
        
    }
    
 
    func startTimer(){
      
       // timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
          // print( self.cTime.dateAndTimetoString())
            if(self.isFast == true){
            self.cTime = Date.now
            }else{
                //self.cTime = self.cTime.addingTimeInterval(0.2)
            }
        })
        }
    

}



extension Date{
    
    func dateAndTimetoString(format: String = "HH:mm:ss") -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
}
