//  
//  SignInVC.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

// MARK: - Makeable

extension SignInVC: Makeable {
    static func make() -> SignInVC {
        return R.storyboard.signInVC.instantiateInitialViewController()!
    }
}

// MARK: - SignInVCDelegate

protocol SignInVCDelegate: class {
    
}

// MARK: - SignInVC

final class SignInVC: BaseVC, ViewModelContainer {

    typealias ViewModel = SignInVM
    
    //MARK: - Outlets
   
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - Properties
    
    weak var delegate: SignInVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    // MARK: - ViewModelContainer
    
    func didSetViewModel(_ viewModel: SignInVM, lifetime: Lifetime) {
        viewModel.email <~ emailTextField.reactive.continuousTextValues
        viewModel.password <~ passwordTextField.reactive.continuousTextValues
        
        signInButton.reactive.pressed = CocoaAction(viewModel.signInAction)
        
        reactive.appErrors <~ viewModel.signInAction.errors
    }
    
    // MARK: - Private
    
    private func config() {
        
    }
}


