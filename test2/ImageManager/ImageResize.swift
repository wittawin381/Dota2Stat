//
//  ImageCompress.swift
//  test2
//
//  Created by Wittawin Muangnoi on 27/2/2564 BE.
//

import Foundation
import UIKit

class ImageResize {
    static var shared = ImageResize()
    func resized(image : UIImage, scale : CGFloat = 0.4) -> UIImage {
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { context in
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        return resizedImage
    }
}
