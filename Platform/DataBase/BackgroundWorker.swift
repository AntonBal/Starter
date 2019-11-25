//
//  BackgroundWorker.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import ReactiveSwift

final class BackgroundWorker: NSObject {
    typealias Action = () -> Void
    
    struct Task {
        let action: Action
        let disposable: Disposable
    }
    
    let thread: Thread
    private let stopAfterPerform: Bool
    
    deinit {
        stop()
    }
    
    init(name: String? = nil,
         stopAfterPerform: Bool = false) {
        self.stopAfterPerform = stopAfterPerform
        self.thread = Thread {
            let runloop = RunLoop.current
            // put port on standby
            runloop.add(NSMachPort(), forMode: .default)
            while !Thread.current.isCancelled {
                //the thread is blocked until any event of runloop was emitted
                runloop.run(mode: .default, before: Date.distantFuture)
            }
        }
        super.init()
        self.thread.name = name
        self.thread.start()
    }
    
    public func stop() {
        thread.cancel()
    }
    
    public func perform(action: @escaping Action) {
        let disposable = AnyDisposable()
        let task = Task(action: action, disposable: disposable)
        if Thread.current == thread {
            action()
        } else {
            perform(#selector(runAction(_:)), on: thread, with: task, waitUntilDone: false)
        }
    }
    
    @objc private func runAction(_ task: Any?) {
        guard let task = task as? Task, !task.disposable.isDisposed else { return }
        task.action()
        if stopAfterPerform {
            stop()
        }
    }
}
