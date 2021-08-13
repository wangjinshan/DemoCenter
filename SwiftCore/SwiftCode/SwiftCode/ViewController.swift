//
//  ViewController.swift
//  SwiftCode
//
//  Created by shan on 2021/5/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let name = "哈哈131****0926急急急123"
        let test = Regex.pregMatchAll(name, regex: "[0-9\\*]+", index: 0)
        print(test)
    }
}

public class Regex {

    public static func pregMatchFirst(_ string: String, regex: String, index: Int = 0) -> String? {
        do {
            let rx = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            if let match = rx.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
                let result: [String] = Regex.stringMatches([match], text: string, index: index)
                return result.count == 0 ? nil : result[0]
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    public static func pregMatchAll(_ string: String, regex: String, index: Int = 0) -> [String] {
        do {
            let rx = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let matches: [NSTextCheckingResult] = rx.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
            return !matches.isEmpty ? Regex.stringMatches(matches, text: string, index: index) : []
        } catch {
            return []
        }
    }

    public static func stringMatches(_ results: [NSTextCheckingResult], text: String, index: Int = 0) -> [String] {
        return results.compactMap { item -> String? in
            if index < item.numberOfRanges {
                let range = item.range(at: index)
                return (text.count >= range.location + range.length) ? ((text as NSString).substring(with: range)) : nil
            }
            return nil
        }
    }
}

