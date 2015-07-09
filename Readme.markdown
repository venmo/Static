# Static

[![Version](https://img.shields.io/github/release/venmo/Static.svg)](https://github.com/venmo/Static/releases) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/Static.svg)](https://cocoapods.org/pods/Static)

Simple static table views for iOS in Swift. Static's goal is to separate model data from presentation. `Row`s and `Section`s are your “view models” for your cells. You simply specify a cell class to use and that handles all of the presentation. See the [usage](usage) section below for details.


## Building

Static is written in Swift 2 so Xcode 7b3 is required. There aren't any dependencies besides system frameworks.


## Installation

[Carthage](https://github.com/carthage/carthage) is the recommended way to install Static. Add the following to your Cartfile:

``` ruby
github "venmo/Static"
```

You can also install with [CocoaPods](https://cocoapods.org):

``` ruby
pod 'Static'
```

For manual installation, it's recommended to add the project as a subproject to your project or workspace and adding the appropriate framework as a target dependency.


## Usage

## Getting Started

To use Static, you need to define [`Row`s](Static/Row.swift) and [`Section`s](Static/Section.swift) to describe your data. Here's a simple example:

```swift
import Static

Section(rows: [
    Row(text: "Hello")
])
```

You can configure `Section`s and `Row`s for anything you want. Here's another example:

```swift
Section(header: "Money", rows: [
    Row(text: "Balance", detailText: "$12.00", accessory: .DisclosureIndicator, selection: {
        // Show statement
    }),
    Row(text: "Transfer to Bank…", cellClass: ButtonCell.self, selection: {
        // Show transfer to bank modal
    })
], footer: "Transfers usually arrive within 1-3 business days.")
```

Since this is Swift, we can instead provide instance methods instead of inline blocks for selections. This makes things really nice. You don't have to switch on index paths in a `tableView:didSelectRowAtIndexPath:` any more!


## Customizing Appearance

The `Row` never has access to the cell. This is by design. The `Row` shouldn't care about its appearance other specifying what will handle it. In practice, this has been really nice. Our cells have one responsibility.

There are several custom cells provided:

* `Value1Cell` — This is the default cell. It's a plain `UITableViewCell` with the `.Value1` style.
* `Value2Cell` — Plain `UITableViewCell` with the `.Value2` style.
* `SubtitleCell` — Plain `UITableViewCell` with the `.Subtitle` style.
* `ButtonCell` — Plain `UITableViewCell` with the `.Default` style. The `textLabel`'s `textColor` is set to the cell's `tintColor`.

All of these conform to [`CellType`](Static/CellType.swift). The gist of the protocol is one method:

```swift
func configure(row row: Row)
```

This gets called by [`TableDataSource`](Static/TableDataSource.swift) (which we'll look at more in a minute) to set the row on the cell. There is a default implementation provided by the protocol that simply sets the `Row`'s `text` on the cell's `textLabel`, etc. If you need to do custom things, this is a great place to hook in.

`Row` also has a `context` property. You can put whatever you want in here that the cell needs to know. You should try to use this as sparingly as possible.


## Working with the Data Source

To hook up your `Section`s and `Row`s to a table view, simply initialize a `TableDataSource`:

```swift
let dataSource = TableDataSource()
dataSource.sections = [
    Section(rows: [
        Row(text: "Hello")
    ])
]
```

Now assign your table view:

```swift
dataSource.tableView = tableView
```

Easy as that! If you modify your data source later, it will automatically update the table view for you. It is important that you don't change the table view's `dataSource` or `delgate`. The `TableDataSource` needs to be those so it can handle events correctly. The purpose of `Static` is to abstract all of that away from you.

Enjoy.

