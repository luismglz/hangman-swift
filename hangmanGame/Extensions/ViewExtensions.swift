//
//  ViewExtensions.swift
//  hangmanGame
//
//  Created by Luis GL on 02/05/22.
//

import Foundation
import UIKit

extension ViewController{
    
}

extension UILabel {
    // Typing animation
    func typingTextAnimation(text: String, timeInterval: Double) {
        self.text = ""
        self.alpha = 0
        var charIndex = 0.0
        
        for letter in text  {
            Timer.scheduledTimer(withTimeInterval: timeInterval * charIndex, repeats: false) { (timer) in
                self.text?.append(letter)
            }
            charIndex -= 1
        }
        
        UIView.animate(withDuration: 1.0) {
            self.alpha = 1.0
        }
        
    }
}
