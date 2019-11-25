//
//  ViewModelContainer.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

// MARK: - ViewModelContainer
protocol ViewModelContainer: class {
    associatedtype ViewModel: ViewModelProtocol
    
    var viewModel: ViewModel { get set }
    func didSetViewModel(_ viewModel: ViewModel, lifetime: Lifetime)
}

private enum ViewModelContainerKeys {
    static var viewModel = "viewModel"
    static var lifetimeToken = "lifetimeToken"
}

extension ViewModelContainer where Self: NSObject {
    
    fileprivate var didLoadTrigger: SignalProducer<(), Never> {
        return self is UIViewController ?
            reactive
                .trigger(for: #selector(UIViewController.viewDidLoad))
                .take(first: 1)
                .observe(on: UIScheduler())
                .producer
            : .init(value: ())
    }
    
    var viewModel: ViewModel {
        get {
            return getAssociatedObject(key: &ViewModelContainerKeys.viewModel)!
        }
        set {
            let viewModel: ViewModel? = getAssociatedObject(key: &ViewModelContainerKeys.viewModel)
            assert(viewModel == nil, "\(type(of: self)) doesn't support reusable viewModel. Use ReusableViewModelContainer instead.")
            
            let token = Lifetime.Token()
            setAssociatedObject(value: token, key: &ViewModelContainerKeys.lifetimeToken, policy: .retain)
            setAssociatedObject(value: newValue, key: &ViewModelContainerKeys.viewModel, policy: .retain)
            
            reactive.makeBindingTarget { $1; $0.didSetViewModel(newValue, lifetime: Lifetime(token)) } <~ didLoadTrigger
        }
    }
}

// MARK: - ReusableViewModelContainer
protocol ReusableViewModelContainer: class {
    associatedtype ViewModel
    
    var viewModel: ViewModel? { get set }
    func prepareForReuse()
    
    func didSetViewModel(_ viewModel: ViewModel, lifetime: Lifetime)
}

extension ReusableViewModelContainer where Self: NSObject {
    
    fileprivate var didLoadTrigger: SignalProducer<(), Never> {
        return self is UIViewController ?
            reactive
                .trigger(for: #selector(UIViewController.viewDidLoad))
                .take(first: 1)
                .observe(on: UIScheduler())
                .producer
            : .init(value: ())
    }
    
    var viewModel: ViewModel? {
        get {
            return getAssociatedObject(key: &ViewModelContainerKeys.viewModel)!
        }
        set {
            removeAssociatedObject(key: &ViewModelContainerKeys.lifetimeToken)
            setAssociatedObject(value: newValue, key: &ViewModelContainerKeys.viewModel, policy: .retain)
            if let newValue = newValue {
                let token = Lifetime.Token()
                setAssociatedObject(value: token, key: &ViewModelContainerKeys.lifetimeToken, policy: .retain)
                reactive.makeBindingTarget { $1; $0.didSetViewModel(newValue, lifetime: Lifetime(token))} <~ didLoadTrigger
            }
            
        }
    }
}
