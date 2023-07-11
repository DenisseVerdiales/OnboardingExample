//
//  ViewController.swift
//  OnboardingScreen
//
//  Created by Cynthia Denisse Verdiales Moreno on 29/06/23.
//

import UIKit
import OnboardingScreeniOS

class ViewController: UIViewController {
    var tappedGetStartedOrSkipBtns = false
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Main Controller"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    let onboardingPages = [
        OnboardingPage(
            title: "What's new",
            imageName: "img1",
            backgroundColor: UIColor(red: 104/255, green: 192/255, blue: 248/255, alpha: 1),
            description: "Login: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        ),
        OnboardingPage(
            title: "Shopping Cart",
            imageName: "img2",
            backgroundColor: UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1),
            description: "Shopping Cart: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        ),
        OnboardingPage(
            title: "Payment",
            imageName: "img3",
            backgroundColor: UIColor(red: 183/255, green: 223/255, blue: 201/255, alpha: 1),
            description: "Payment: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        )
    ]
    
     override func viewDidLoad() {
         super.viewDidLoad()
         setUpUI()
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if !tappedGetStartedOrSkipBtns {
            let onboardingVC = OnboardingViewController(onboardingPages: onboardingPages)
            onboardingVC.onboardingDelegate = self
            onboardingVC.modalPresentationStyle = .fullScreen
            present(onboardingVC, animated: true, completion: nil)
        }
    }
    
    func setUpUI() {
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
}
extension ViewController: OnboardingViewControllerDelegate {
    func onboardingDidFinish(_ onboardingViewController: OnboardingScreeniOS.OnboardingViewController) {
        // Handle onboarding completion
        tappedGetStartedOrSkipBtns = true
        dismiss(animated: true, completion: nil)
    }
}

