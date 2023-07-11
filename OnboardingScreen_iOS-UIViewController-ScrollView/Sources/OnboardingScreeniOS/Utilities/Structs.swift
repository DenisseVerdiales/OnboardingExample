//
//  File.swift
//  
//
//  Created by Cynthia Denisse Verdiales Moreno on 03/07/23.
//

import UIKit


public struct OnboardingPage {
    let title: String
    let imageName: String
    let backgroundColor: UIColor
    let description: String
    
    public init(title: String, imageName: String, backgroundColor: UIColor, description: String) {
        self.title = title
        self.imageName = imageName
        self.backgroundColor = backgroundColor
        self.description = description
    }
}
