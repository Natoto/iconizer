//
//  NSImageExtensions.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 28/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

extension NSImage {
    
    /**
    * Copies the current image and resizes it to the size of the given NSSize.
    *
    * :param: size Size of the image copy.
    *
    * :returns: The resized image copy.
    */
    func copyWithSize(size: NSSize) -> NSImage? {
        // Create a new rect with given width and height
        let frame    = NSMakeRect(0, 0, size.width, size.height)
        // Extract an image representation for the frame rect
        let imageRep = self.bestRepresentationForRect(frame, context: nil, hints: nil)
        // Create an empty NSImage with the given size
        let newImage = NSImage(size: size)
        
        // Draw the newly sized image
        newImage.lockFocus()
        imageRep?.drawInRect(frame)
        newImage.unlockFocus()
        
        // Return the resized image
        return newImage
    }
    
    func PNGRepresentation() -> NSData {
        // Create an empty NSBitmapImageRep.
        var bitmap: NSBitmapImageRep
        
        // Get an NSBitmapImageRep of the current image.
        self.lockFocus()
        bitmap = NSBitmapImageRep(focusedViewRect: NSMakeRect(0, 0, self.size.width, self.size.height))!
        self.unlockFocus()
        
        // Return NSPNGFileType representation of the bitmap object.
        return bitmap.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [:])!
    }
}
