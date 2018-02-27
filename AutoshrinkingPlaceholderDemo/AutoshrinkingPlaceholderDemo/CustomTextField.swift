//
//  CustomTextField.swift
//  AutoshrinkingPlaceholderDemo
//
//  Created by Nicolás Miari on 2018/02/27.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

///
/// Demonstrates auto-shrinking behaviour of the placeholder label to fit the
/// requested text.
///
/// Notice how the shrinking of the placeholder does not affect in any way the
/// set font size of the input text.
///
class CustomTextField: UITextField {

    // MARK: - UITextField

    override func drawPlaceholder(in rect: CGRect) {
        guard let placeholder = self.placeholder else {
            return // Method shouldn't have been called in the first place
        }
        guard let font = self.font else {
            return // This should never happen
        }

        // Calculate how much space it will take to draw the placeholder text at
        // the preset font size:
        //
        var attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font]
        var newSize = (placeholder as NSString).size(withAttributes: attributes)

        guard newSize.width > rect.size.width else {
            // Placeholder already fits (NO PROBLEM); Use default behaviour:
            //
            return super.drawPlaceholder(in: rect)
        }

        // Find font size that fits, and draw centered vertically:

        // NOTE:
        // We need to iterate until the size generated fits, because text
        // rendering seems to not be linear (i.e., half the font size does not
        // render a text that is half the width); perhaps due to the
        // complexities of text metrics? For Japanese text, that is fixed width,
        // it seems to work at once though.

        var iterations = 0 // (for diagnosis)

        var pointSize = font.pointSize
        while newSize.width > rect.width {
            // Recalculate scaling factor, update point size and try again:
            //
            let scaleFactor = (rect.size.width / newSize.width)
            pointSize = floor(pointSize * scaleFactor)
            let newFont = UIFont(descriptor: font.fontDescriptor, size: pointSize)
            attributes[NSAttributedStringKey.font] = newFont
            newSize = (placeholder as NSString).size(withAttributes: attributes)
            iterations += 1
        }
        print("Iterations: \(iterations)")

        var newRect = rect
        newRect.size.height = newSize.height
        newRect.origin.y = ((rect.height - newSize.height)/2)

        // Before drawing, append the color attribute (not needed until now):
        //
        let color = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        attributes[NSAttributedStringKey.foregroundColor] = color

        // Go:
        //
        (placeholder as NSString).draw(in: newRect, withAttributes: attributes)
    }
}
