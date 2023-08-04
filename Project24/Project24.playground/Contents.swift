import UIKit



extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
}

extension String {
    var isNumeric: Bool {
        // Use the NumberFormatter to check if the string can be converted to a number
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter.number(from: self) != nil
    }
}

extension String {
    var lines: [String] {
        var result: [String] = []
        self.enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
}

let multilineString = """
    Line 1
    Line 2
    Line 3
    """

let lines = multilineString.lines
print(lines)
// Output: ["Line 1", "Line 2", "Line 3"]


