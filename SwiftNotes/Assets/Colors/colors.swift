// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cff7ff"></span>
  /// Alpha: 100% <br/> (0xcff7ffff)
  internal static let backgroundColor = ColorName(rgbaValue: 0xcff7ffff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1b262c"></span>
  /// Alpha: 100% <br/> (0x1b262cff)
  internal static let defaultText = ColorName(rgbaValue: 0x1b262cff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bbe1fa"></span>
  /// Alpha: 100% <br/> (0xbbe1faff)
  internal static let lightTint = ColorName(rgbaValue: 0xbbe1faff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#0f4c75"></span>
  /// Alpha: 100% <br/> (0x0f4c75ff)
  internal static let mainTint = ColorName(rgbaValue: 0x0f4c75ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#888888"></span>
  /// Alpha: 100% <br/> (0x888888ff)
  internal static let placeholder = ColorName(rgbaValue: 0x888888ff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
