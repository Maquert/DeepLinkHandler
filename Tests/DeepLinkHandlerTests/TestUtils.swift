// Compare two different closures. They are reference types after all.
func assertDifferentClosures<T: AnyObject>(_ closure1: T, _ closure2: T) -> Bool {
    Unmanaged.passUnretained(closure1).toOpaque() != Unmanaged.passUnretained(closure2).toOpaque()
}


