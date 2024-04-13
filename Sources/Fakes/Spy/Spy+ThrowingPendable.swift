import Foundation

public typealias ThrowingPendableSpy<Arguments, Success, Failure: Error> = Spy<Arguments, ThrowingDynamicPendable<Success, Failure>>

extension Spy {
    /// Create a throwing pendable Spy that is pre-stubbed to return a pending that will block for a bit before returning success.
    public convenience init<Success: Sendable, Failure: Error>(pendingSuccess: Success) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.init(.pending(fallback: .success(pendingSuccess)))
    }

    /// Create a throwing pendable Spy that is pre-stubbed to return a pending that will block for a bit before returning Void.
    public convenience init<Failure: Error>() where Returning == ThrowingDynamicPendable<(), Failure> {
        self.init(.pending(fallback: .success(())))
    }

    /// Create a throwing pendable Spy that is pre-stubbed to return a pending that will block for a bit before throwing an error.
    public convenience init<Success: Sendable, Failure: Error>(pendingFailure: Failure) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.init(.pending(fallback: .failure(pendingFailure)))
    }

    /// Create a throwing pendable Spy that is pre-stubbed to return a finished & successful value.
    public convenience init<Success: Sendable, Failure: Error>(success: Success) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.init(.finished(.success(success)))
    }

    /// Create a throwing pendable Spy that is pre-stubbed to throw the given error.
    public convenience init<Success: Sendable, Failure: Error>(failure: Failure) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.init(.finished(.failure(failure)))
    }
}

extension Spy {
    /// Resolve the pendable Spy's stub with the success value.
    public func resolveStub<Success: Sendable, Failure: Error>(success: Success) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.resolveStub(with: .success(success))
    }

    /// Resolve the pendable spy's stub with the given error
    public func resolveStub<Success: Sendable, Failure: Error>(failure: Failure) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.resolveStub(with: .failure(failure))
    }
}

extension Spy {
    /// Update the pendable Spy's stub to be in a pending state.
    public func stub<Success: Sendable, Failure: Error>(pendingSuccess: Success) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.stub(.pending(fallback: .success(pendingSuccess)))
    }

    /// Update the pendable Spy's stub to be in a pending state.
    public func stub<Success: Sendable, Failure: Error>(pendingFailure: Failure) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.stub(.pending(fallback: .failure(pendingFailure)))
    }

    /// Update the throwing pendable Spy's stub to be successful, with the given value.
    ///
    /// - parameter success: The value to return when `callAsFunction` is called.
    public func stub<Success: Sendable, Failure: Error>(success: Success) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.stub(.finished(.success(success)))
    }

    /// Update the throwing pendable Spy's stub to throw the given error.
    ///
    /// - parameter failure: The error to throw when `callAsFunction` is called.
    public func stub<Success: Sendable, Failure: Error>(failure: Failure) where Returning == ThrowingDynamicPendable<Success, Failure> {
        self.stub(.finished(.failure(failure)))
    }
}

extension Spy {
    // Returning == ThrowingPendable
    /// Records the arguments and handles the result according to ``Pendable/call(fallbackDelay:)``.
    /// This call then throws or returns the success, according to `Result.get`.
    ///
    /// - parameter arguments: The arguments to record.
    /// - parameter pendingDelay: The amount of seconds to delay if the `Pendable` is .pending before
    /// throwing a `PendableInProgressError`. If the `Pendable` is .finished, then this value is ignored.
    public func callAsFunction<Success: Sendable, Failure: Error>(
        _ arguments: Arguments,
        fallbackDelay: TimeInterval = PendableDefaults.delay
    ) async throws -> Success where Returning == ThrowingDynamicPendable<Success, Failure> {
        return try await call(arguments).call(fallbackDelay: fallbackDelay).get()
    }

    /// Records that a call was made and handles the result according to ``Pendable/call(fallbackDelay:)``.
    /// This call then throws or returns the success, according to `Result.get`.
    ///
    /// - parameter pendingDelay: The amount of seconds to delay if the `Pendable` is .pending before
    /// throwing a `PendableInProgressError`. If the `Pendable` is .finished, then this value is ignored.
    public func callAsFunction<Success: Sendable, Failure: Error>(
        fallbackDelay: TimeInterval = PendableDefaults.delay
    ) async throws -> Success where Arguments == Void, Returning == ThrowingDynamicPendable<Success, Failure> {
        return try await call(()).call(fallbackDelay: fallbackDelay).get()
    }
}
