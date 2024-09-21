// Compare two identical closures. They are reference types after all.
func assertEqualClosures<T: AnyObject>(_ closure1: T, _ closure2: T) -> Bool {
    Unmanaged.passUnretained(closure1).toOpaque() == Unmanaged.passUnretained(closure2).toOpaque()
}

// Compare two different closures. They are reference types after all.
func assertDifferentClosures<T: AnyObject>(_ closure1: T, _ closure2: T) -> Bool {
    Unmanaged.passUnretained(closure1).toOpaque() != Unmanaged.passUnretained(closure2).toOpaque()
}

func asPointer(_ closure: AnyObject) -> UnsafeMutableRawPointer {
  Unmanaged.passUnretained(closure).toOpaque()
}

