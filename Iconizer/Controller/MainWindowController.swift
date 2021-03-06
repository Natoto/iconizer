//
// MainWindowController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Cocoa

///  Handles the MainWindow view.
class MainWindowController: NSWindowController, NSWindowDelegate {

  /// Points to the SegmentedControl, which determines which view is currently selected.
  @IBOutlet weak var exportType: NSSegmentedControl!

  /// Represents the currently selected view.
  var currentView: NSViewController?

  /// Access the user's preferences.
  let userPrefs = PreferenceManager()

  // Override the windowNibName property.
  override var windowNibName: String {
    return "MainWindow"
  }

  // MARK: Window delegate

  override func windowDidLoad() {
    super.windowDidLoad()

    // Unwrap the window property. I don't even know if window can be nil, but
    // as you know: Everytime we force unwrap something, a kitty dies.
    if let window = self.window {
      // Hide the window title, to get the unified toolbar.
      window.titleVisibility = .hidden
    }
    // Change the content view to the last selected view...
    self.changeView(ViewControllerTag(rawValue: userPrefs.selectedExportType))
    // ...and set the selectedSegment of NSSegmentedControl to the corresponding value.
    self.exportType.selectedSegment = userPrefs.selectedExportType
  }

  // Save the user preferences before the application terminates.
  func windowWillClose(_ notification: Notification) {
    userPrefs.selectedExportType = self.exportType.selectedSegment
  }

  // MARK: Actions

  ///  Select the export type.
  ///
  ///  - parameter sender: NSSegmentedControl; 'Mode' set to 'Select One'.
  @IBAction func selectView(_ sender: NSSegmentedControl) {
    changeView(ViewControllerTag(rawValue: sender.selectedSegment))
  }

  /// Saves the image/s as asset catalog.
  ///
  /// - Parameter sender: NSButton, that sent the action.
  @IBAction func saveDocument(_ sender: NSButton) {
    // Unwrap the export view.
    guard let currentView = self.currentView else {
      return
    }
    // Create a new NSSavePanel.
    let exportSheet = NSSavePanel()
    // Open the save panel.
    exportSheet.beginSheetModal(for: self.window!) { (result: Int) in
      // The user clicked "Export".
      if result == NSFileHandlingPanelOKButton {
        do {
          // Unwrap the file url and get rid of the last path component.
          guard let url = exportSheet.url?.deletingLastPathComponent() else {
            return
          }
          // Generate the required images.
          try currentView.generateRequiredImages()
          // Save the currently generated asset catalog to the
          // selected file URL.
          try currentView.saveAssetCatalogNamed(exportSheet.nameFieldStringValue, toURL: url)
          // Open the generated asset catalog in Finder.
          NSWorkspace.shared().open(url.appendingPathComponent("Iconizer Assets", isDirectory: true))
        } catch {
          // Something went somewhere terribly wrong...
          if let error = error as? String {
            NSLog(error)
          }
          return
        }
      }
    }
  }

  /// Saves the image/s as asset catalog.
  ///
  /// - Parameter sender: NSButton that sent the action.
  @IBAction func saveDocumentAs(_ sender: NSButton) {
    saveDocument(sender)
  }

  /// Present an open dialog to the user.
  ///
  /// - Parameter sender: NSButton, that sent the action.
  @IBAction func openDocument(_ sender: NSButton) {
    // Create a new NSOpenPanel instance.
    let openPanel = NSOpenPanel()
    // Configure the NSOpenPanel
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories    = false
    openPanel.canCreateDirectories    = false
    openPanel.canChooseFiles          = true
    // Present the open panel to the user and get the selected file.
    let response = openPanel.runModal()
    if response == NSModalResponseOK {
      do {
        // Unwrap the url to the selected image an the currently active view.
        guard let url = openPanel.url, let currentView = self.currentView else {
          return
        }
        // Open the selected image file.
        try currentView.openSelectedImage(NSImage(contentsOf: url))
      } catch {
        if let error = error as? String {
          NSLog(error)
        }
        return
      }
    }
  }

  // MARK: Changing View

  ///  Swaps the current ViewController with a new one.
  ///
  ///  - parameter view: Takes a ViewControllerTag.
  func changeView(_ view: ViewControllerTag?) {
    // Unwrap the current view, if any...
    if let currentView = self.currentView {
      // ...and remove it from the superview.
      currentView.view.removeFromSuperview()
    }
    // Check which ViewControllerTag is given. And set self.currentView to
    // the correspondig view.
    if let view = view {
      switch view {
      case .appIconViewControllerTag:
        self.currentView = AppIconViewController()

      case .imageSetViewControllerTag:
        self.currentView = ImageSetViewController()

      case .launchImageViewControllerTag:
        self.currentView = LaunchImageViewController()
      }
    }

    // Unwrap the selected ViewController and the main window.
    if let currentView = self.currentView, let window = self.window {
      // Resize the main window to fit the selected view.
      resizeWindowForContentSize(currentView.view.frame.size)
      // Set the main window's contentView to the selected view.
      window.contentView = currentView.view
    }
  }

  /// Resizes the main window to the given size.
  ///
  /// - parameter size: The new size of the main window.
  func resizeWindowForContentSize(_ size: NSSize) {
    // Unwrap the main window object.
    guard let window = self.window else {
      // Is this even possible???
      return
    }

    // Get the content rect of the main window.
    let windowContentRect = window.contentRect(forFrameRect: window.frame)
    // Create a new content rect for the given size (except width).
    let newContentRect    = NSMakeRect(windowContentRect.minX,
                                       windowContentRect.maxY - size.height,
                                       windowContentRect.size.width,
                                       size.height)

    // Create a new frame rect from the content rect.
    let newWindowFrame = window.frameRect(forContentRect: newContentRect)

    // Set the window frame to the new frame.
    window.setFrame(newWindowFrame, display: true, animate: true)
  }

}
