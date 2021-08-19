//
// Created by Mengyu Li on 2021/8/19.
//

#if canImport(WASILibc)
// No locking on WASILibc
#else

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import Darwin
#elseif os(Windows)
import WinSDK
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported runtime")
#endif

public final class RecursiveLock {
    #if os(Windows)
    fileprivate let mutex: UnsafeMutablePointer<SRWLOCK> =
        UnsafeMutablePointer.allocate(capacity: 1)
    #else
    fileprivate let mutex: UnsafeMutablePointer<pthread_mutex_t> =
        UnsafeMutablePointer.allocate(capacity: 1)
    #endif

    /// Create a new lock.
    public init() {
        #if os(Windows)
        InitializeSRWLock(mutex)
        #else
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, .init(PTHREAD_MUTEX_RECURSIVE))

        let err = pthread_mutex_init(mutex, &attr)
        precondition(err == 0, "\(#function) failed in pthread_mutex with error \(err)")
        pthread_mutexattr_destroy(&attr)
        #endif
    }

    deinit {
        #if os(Windows)
        // SRWLOCK does not need to be free'd
        #else
        let err = pthread_mutex_destroy(self.mutex)
        precondition(err == 0, "\(#function) failed in pthread_mutex with error \(err)")
        #endif
        self.mutex.deallocate()
    }

    /// Acquire the lock.
    ///
    /// Whenever possible, consider using `withLock` instead of this method and
    /// `unlock`, to simplify lock handling.
    public func lock() {
        #if os(Windows)
        AcquireSRWLockExclusive(mutex)
        #else
        let err = pthread_mutex_lock(mutex)
        precondition(err == 0, "\(#function) failed in pthread_mutex with error \(err)")
        #endif
    }

    /// Release the lock.
    ///
    /// Whenever possible, consider using `withLock` instead of this method and
    /// `lock`, to simplify lock handling.
    public func unlock() {
        #if os(Windows)
        ReleaseSRWLockExclusive(mutex)
        #else
        let err = pthread_mutex_unlock(mutex)
        precondition(err == 0, "\(#function) failed in pthread_mutex with error \(err)")
        #endif
    }
}

public extension RecursiveLock {
    /// Acquire the lock for the duration of the given block.
    ///
    /// This convenience method should be preferred to `lock` and `unlock` in
    /// most situations, as it ensures that the lock will be released regardless
    /// of how `body` exits.
    ///
    /// - Parameter body: The block to execute while holding the lock.
    /// - Returns: The value returned by the block.
    @inlinable
    func withLock<T>(_ body: () throws -> T) rethrows -> T {
        lock()
        defer {
            self.unlock()
        }
        return try body()
    }

    // specialise Void return (for performance)
    @inlinable
    func withLockVoid(_ body: () throws -> Void) rethrows {
        try withLock(body)
    }
}

#endif
