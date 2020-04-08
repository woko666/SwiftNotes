# Swift Notes

`Swift Notes` is a simple note management app written in Swift.

![Notes][Notes]

## Architecture & Dependencies

This app uses MVVM-C with services as a core architectural pattern. Dependencies include RxSwift, RxDataSources, Moya, Swinject, Quick/Nimble, Realm, SwiftLint, Swiftgen, SpecLeaks...

## Offline Capabilities

To keep things simple, this app uses a Realm layer to cache the last known list of notes. Other functionality (CUD) requires an internet connection.

## Multi-device Access

In order to solve issues with notes being concurrently edited on different devices with a different cache state, this app implements a simple CAS versioning scheme. Since the backend doesn't support CAS version numbers, we're emulating them client-side using a hash of the note title.

## Notes API

I've implemented my own API to persist notes; code to handle the mock API can be found at the bottom of `NotesProvider` (commented out).

## UI

The app uses `RxDataSources` to populate the table view with notes. A delay is added to async operations to showcase loading dialogs.

## Testing

The following tests are implemented:

- VC unit tests
- VM unit tests
- Service mocks
- Service tests
- Basic VC leak tests (init & viewDidLoad). I actually caught one memory leak in `NotesDetailViewController` - a forgotten `[weak self]` in a `onNext` closure. Useful!
- A basic UI test

## Project Structure

- **Assets** - xcassets, fonts, colors...
- **Flows** - coordinator flows, in this case only Notes
- **Models** - note models and related services
- **Utility** - utility classes

## Build & Run

Open `SwiftNotes.xcworkspace`, build & run the `SwiftNotes` target. Select `Product` -> `Test` to run tests.


[Notes]: notes.gif