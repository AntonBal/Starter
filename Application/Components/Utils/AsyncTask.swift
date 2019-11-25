//
//  AsyncTask.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import ReactiveSwift

typealias AsyncTask<Value> = SignalProducer<Value, AppError>
typealias AsyncTaskValue<Value> = SignalProducer<Value, Never>
typealias PipeValue<V> = (output: Signal<V, Never>, input: Signal<V, Never>.Observer)
typealias Pipe<V, E:Error> = (output: Signal<V, E>, input: Signal<V, E>.Observer)
