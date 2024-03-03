//
//  NWPathMonitor+Combine.swift
//  NetworkConnectivity
//
//  Created by Zafar on 13/07/21.
//
import Combine
import Network

// MARK: - NWPathMonitor Subscription

public extension NWPathMonitor {
    class NetworkStatusSubscription<S: Subscriber>: Subscription where S.Input == NWPath.Status {
        private let subscriber: S?

        private let monitor: NWPathMonitor
        private let queue: DispatchQueue

        init(
            subscriber: S,
            monitor: NWPathMonitor,
            queue: DispatchQueue
        ) {
            self.subscriber = subscriber
            self.monitor = monitor
            self.queue = queue
        }

        public func request(_: Subscribers.Demand) {
            monitor.pathUpdateHandler = { [weak self] path in
                guard let self else { return }

                _ = self.subscriber?.receive(path.status)
            }

            monitor.start(queue: queue)
        }

        public func cancel() {
            // 3
            monitor.cancel()
        }
    }
}

// MARK: - NWPathMonitor Publisher

public extension NWPathMonitor {
    struct NetworkStatusPublisher: Publisher {
        // 1
        public typealias Output = NWPath.Status
        public typealias Failure = Never

        // 2
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue

        init(monitor: NWPathMonitor,
             queue: DispatchQueue) {
            self.monitor = monitor
            self.queue = queue
        }

        public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, NWPath.Status == S.Input {
            let subscription = NetworkStatusSubscription(
                subscriber: subscriber,
                monitor: monitor,
                queue: queue
            )

            subscriber.receive(subscription: subscription)
        }
    }

    func publisher(queue: DispatchQueue) -> NWPathMonitor.NetworkStatusPublisher {
        return NetworkStatusPublisher(
            monitor: self, queue: queue
        )
    }
}
