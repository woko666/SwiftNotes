// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Swift Notes
  internal static let appName = L10n.tr("Localizable", "App Name")
  /// Are you sure you want to delete this note?
  internal static let deleteNoteText = L10n.tr("Localizable", "Delete Note Text")
  /// Delete Note
  internal static let deleteNoteTitle = L10n.tr("Localizable", "Delete Note Title")
  /// Deleting...
  internal static let deleting = L10n.tr("Localizable", "Deleting")
  /// Error
  internal static let error = L10n.tr("Localizable", "Error")
  /// An error has occurred while deleting this note. Please try again.
  internal static let errorDeletingNote = L10n.tr("Localizable", "Error Deleting Note")
  /// The note has changed on the server since you started editing it. Do you want to save this version or reload the note from server?
  internal static let errorNoteChanged = L10n.tr("Localizable", "Error Note Changed")
  /// An error has occurred while saving this note. Please try again.
  internal static let errorSavingNote = L10n.tr("Localizable", "Error Saving Note")
  /// No
  internal static let no = L10n.tr("Localizable", "No")
  /// Note Changed
  internal static let noteChanged = L10n.tr("Localizable", "Note Changed")
  /// Enter your note here...
  internal static let notePlaceholder = L10n.tr("Localizable", "Note Placeholder")
  /// Notes
  internal static let notes = L10n.tr("Localizable", "Notes")
  /// OK
  internal static let ok = L10n.tr("Localizable", "OK")
  /// Pull to refresh
  internal static let pullToRefresh = L10n.tr("Localizable", "Pull to refresh")
  /// Reload From Server
  internal static let reloadFromServer = L10n.tr("Localizable", "Reload From Server")
  /// Save This Note
  internal static let saveThisNote = L10n.tr("Localizable", "Save This Note")
  /// Sending...
  internal static let sending = L10n.tr("Localizable", "Sending")
  /// Yes
  internal static let yes = L10n.tr("Localizable", "Yes")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
