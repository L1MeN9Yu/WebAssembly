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

/// A reader/writer threading lock based on `libpthread` instead of `libdispatch`.
///
/// This object provides a lock on top of a single `pthread_rwlock_t`. This kind
/// of lock is safe to use with `libpthread`-based threading models, such as the
/// one used by NIO. On Windows, the lock is based on the substantially similar
/// `SRWLOCK` type.
public final class ReadWriteLock {
    #if os(Windows)
    fileprivate let rwlock: UnsafeMutablePointer<SRWLOCK> =
        UnsafeMutablePointer.allocate(capacity: 1)
    fileprivate var shared: Bool = true
    #else
    fileprivate let rwlock: UnsafeMutablePointer<pthread_rwlock_t> =
        UnsafeMutablePointer.allocate(capacity: 1)
    #endif

    /// Create a new lock.
    public init() {
        #if os(Windows)
        InitializeSRWLock(rwlock)
        #else
        let err = pthread_rwlock_init(rwlock, nil)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
        #endif
    }

    deinit {
        #if os(Windows)
        // SRWLOCK does not need to be free'd
        #else
        let err = pthread_rwlock_destroy(self.rwlock)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
        #endif
        self.rwlock.deallocate()
    }

    /// Acquire a reader lock.
    ///
    /// Whenever possible, consider using `withReaderLock` instead of this
    /// method and `unlock`, to simplify lock handling.
    public func lockRead() {
        #if os(Windows)
        AcquireSRWLockShared(rwlock)
        shared = true
        #else
        let err = pthread_rwlock_rdlock(rwlock)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
        #endif
    }

    /// Acquire a writer lock.
    ///
    /// Whenever possible, consider using `withWriterLock` instead of this
    /// method and `unlock`, to simplify lock handling.
    public func lockWrite() {
        #if os(Windows)
        AcquireSRWLockExclusive(rwlock)
        shared = false
        #else
        let err = pthread_rwlock_wrlock(rwlock)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
        #endif
    }

    /// Release the lock.
    ///
    /// Whenever possible, consider using `withReaderLock` and `withWriterLock`
    /// instead of this method and `lockRead` and `lockWrite`, to simplify lock
    /// handling.
    public func unlock() {
        #if os(Windows)
        if shared {
            ReleaseSRWLockShared(rwlock)
        } else {
            ReleaseSRWLockExclusive(rwlock)
        }
        #else
        let err = pthread_rwlock_unlock(rwlock)
        precondition(err == 0, "\(#function) failed in pthread_rwlock with error \(err)")
        #endif
    }
}

public extension ReadWriteLock {
    /// Acquire the reader lock for the duration of the given block.
    ///
    /// This convenience method should be preferred to `lockRead` and `unlock`
    /// in most situations, as it ensures that the lock will be released
    /// regardless of how `body` exits.
    ///
    /// - Parameter body: The block to execute while holding the reader lock.
    /// - Returns: The value returned by the block.
    @inlinable
    func withReaderLock<T>(_ body: () throws -> T) rethrows -> T {
        lockRead()
        defer {
            self.unlock()
        }
        return try body()
    }

    /// Acquire the writer lock for the duration of the given block.
    ///
    /// This convenience method should be preferred to `lockWrite` and `unlock`
    /// in most situations, as it ensures that the lock will be released
    /// regardless of how `body` exits.
    ///
    /// - Parameter body: The block to execute while holding the writer lock.
    /// - Returns: The value returned by the block.
    @inlinable
    func withWriterLock<T>(_ body: () throws -> T) rethrows -> T {
        lockWrite()
        defer {
            self.unlock()
        }
        return try body()
    }

    // specialise Void return (for performance)
    @inlinable
    func withReaderLockVoid(_ body: () throws -> Void) rethrows {
        try withReaderLock(body)
    }

    // specialise Void return (for performance)
    @inlinable
    func withWriterLockVoid(_ body: () throws -> Void) rethrows {
        try withWriterLock(body)
    }
}
#endif
