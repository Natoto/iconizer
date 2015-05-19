//
//  MainWindowController.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 06/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {
    
    override var windowNibName: String? {
        return "MainWindow"
    }
    
    @IBOutlet weak var watch: NSButton!             // Generate Apple Watch icons - Checkbox: Int 1/0
    @IBOutlet weak var iphone: NSButton!            // Generate iPhone icons - Checkbox: Int 1/0
    @IBOutlet weak var ipad: NSButton!              // Generate iPad icons - Checkbox: Int 1/0
    @IBOutlet weak var mac: NSButton!               // Generate OS X icons - Checkbox: Int 1/0
    @IBOutlet weak var car: NSButton!               // Generate CarPlay icons - Checkbox: Int 1/0
    @IBOutlet weak var combined: NSButton!          // Generate selected platforms into one catalog: Int 1/0
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    
    let imageGenerator = ImageGenerator()            // ImageGenerator to resize the given image to the appropriate sizes
    let prefManager    = PreferenceManager()         // Handle the user preferences in an extra crontroller
    let fileManager    = FileManager()               // Save the generated images
    
    // Which platforms are actually choosen?
    var enabledPlatforms: [String] {
        get {
            var tmp: [String] = []
            if watch.state == NSOnState {
                tmp.append(watch.title)
            }
            
            if ipad.state == NSOnState {
                tmp.append(ipad.title)
            }
            
            if iphone.state == NSOnState {
                tmp.append(iphone.title)
            }
            
            if mac.state == NSOnState {
                tmp.append(mac.title)
            }
            
            if car.state == NSOnState {
                tmp.append("car")
            }
            
            return tmp
        }
    }
    
    
    
    // Override windowDidLoad to apply the user defaults
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Hide the window title
        window!.titleVisibility = .Hidden
        
        // Set Checkbox states
        watch.state    = prefManager.generateForAppleWatch
        iphone.state   = prefManager.generateForIPhone
        ipad.state     = prefManager.generateForIPad
        mac.state      = prefManager.generateForMac
        car.state      = prefManager.generateForCar
        combined.state = prefManager.combinedAsset
    }
    
    
    // Write back user defaults
    func windowWillClose(notification: NSNotification) {
        prefManager.generateForAppleWatch = watch.state
        prefManager.generateForIPad       = ipad.state
        prefManager.generateForIPhone     = iphone.state
        prefManager.generateForMac        = mac.state
        prefManager.generateForCar        = car.state
        prefManager.combinedAsset         = combined.state
    }
    
    
    // Open the NSSavePanel, to save an image asset
    func openExportPanel() {
        // Use an NSOpenPanel to let the user choose a directory
        let saveModal = NSOpenPanel()
        
        saveModal.canChooseDirectories = true
        saveModal.canChooseFiles       = false
        saveModal.prompt               = "Export"
        
        saveModal.beginSheetModalForWindow(window!) { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton {
                // Save generated images to the user choosen directory
                if self.combined.state == NSOnState {
                    // Either as combined asset...
                    self.fileManager.saveImageAssetToDirectoryURL(saveModal.URL, usingImages: self.imageGenerator.icnImages, asCombinedAsset: true)
                } else {
                    // ...or as individual assets
                    self.fileManager.saveImageAssetToDirectoryURL(saveModal.URL, usingImages: self.imageGenerator.icnImages)
                }
                
                if let url = saveModal.URL {
                    let openURL = url.URLByAppendingPathComponent("/Iconizer Assets", isDirectory: true)
                    NSWorkspace.sharedWorkspace().openURL(openURL)
                }
            }
        }
    }
    
    
    func displayAlertWithMessage(message: String, andInformativeText text: String) {
        let alert = NSAlert()
        
        alert.messageText = message
        alert.informativeText = text
        
        alert.beginSheetModalForWindow(window!, completionHandler: nil)
    }
    
    
    @IBAction func export(sender: NSToolbarItem) {
        // Abort generation when no platforms are selected
        if enabledPlatforms.count == 0 {
            displayAlertWithMessage("No platforms selected!", andInformativeText: "You have to select at least one platform.")
            return
        }
        
        // Unwrap the NSImageWell's image
        if let img = imageView.image {
            // Display the progress indicator and start the animation
            progressIndicator.hidden = false
            progressIndicator.startAnimation(self)
            
            // Generate the required images
            imageGenerator.generateImagesFrom(img, forPlatforms: enabledPlatforms)
            openExportPanel()
            
            // Processing finished! Hide the progress indicator and stop the animation
            progressIndicator.hidden = true
            progressIndicator.stopAnimation(self)
        } else {
            // Abort when no image is given
            displayAlertWithMessage("No image!", andInformativeText: "You have to provide an image to convert. drag & drop one onto the white bordered, grey area.")
        }
    }
}
