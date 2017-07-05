//
//  UIImageExtension.swift
//  EmoChat
//
//  Created by Vladyslav Tsykhmystro on 19.06.17.
//  Copyright © 2017 SoftServe. All rights reserved.
//

import Foundation
import UIKit
import ImageIO

extension UIImage {
    
    class func imageFromURL(url: String) -> UIImage {
        
        var imageFromURL = UIImage()
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                imageFromURL = UIImage(data: data as Data)!
            }
        }
        return imageFromURL
    }
    
    
    class func createFinalImg(logoImages: Array<UIImage>)  -> UIImage {

        var finalMixedImage = UIImage()
        
        if (logoImages.count == 1) {
            finalMixedImage = logoImages[0]
        } else if (logoImages.count == 2) {
            finalMixedImage = getMixed2Img(image1: logoImages[0], image2: logoImages[1])
        } else if (logoImages.count == 3) {
            finalMixedImage = getMixed3Img(image1: logoImages[0], image2: logoImages[1], image3: logoImages[2])
        } else if (logoImages.count == 4) {
            finalMixedImage = getMixed4Img(image1: logoImages[0], image2: logoImages[1], image3: logoImages[2], image4: logoImages[3])
        } else if (logoImages.count > 4) {
            var tempArray = logoImages
            
            let randomIndex1 = Int(arc4random_uniform(UInt32(tempArray.count)))
            let image1 = tempArray[randomIndex1]
            tempArray.remove(at: randomIndex1)
            let randomIndex2 = Int(arc4random_uniform(UInt32(tempArray.count)))
            let image2 = tempArray[randomIndex2]
            tempArray.remove(at: randomIndex2)
            let randomIndex3 = Int(arc4random_uniform(UInt32(tempArray.count)))
            let image3 = tempArray[randomIndex3]
            tempArray.remove(at: randomIndex3)
            let randomIndex4 = Int(arc4random_uniform(UInt32(tempArray.count)))
            let image4 = tempArray[randomIndex4]
            tempArray.remove(at: randomIndex4)
            finalMixedImage = getMixed4Img(image1: image1, image2: image2, image3: image3, image4: image4)
        }
        
        return finalMixedImage
    }
    
    class func getMixed2Img(image1: UIImage, image2: UIImage) -> UIImage {
        
        let size = CGSize(width:(image1.size.width + image2.size.width), height:image1.size.height)
        
        UIGraphicsBeginImageContext(size)
        
        image1.draw(in: CGRect(x:0, y:0, width:image1.size.width, height:image1.size.height))
        image2.draw(in: CGRect(x:image1.size.width, y:0, width:image2.size.width, height:image2.size.height))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    class func getMixed3Img(image1: UIImage, image2: UIImage, image3: UIImage) -> UIImage {
        
        let size = CGSize(width:(image1.size.width + image2.size.width), height:(image2.size.height + image3.size.height))
        
        UIGraphicsBeginImageContext(size)
        
        image1.draw(in: CGRect(x:0, y:(size.height/4), width:image1.size.width, height:image1.size.height))
        image2.draw(in: CGRect(x:image1.size.width, y:0, width:image2.size.width, height:image2.size.height))
        image3.draw(in: CGRect(x:image1.size.width, y:image2.size.height, width:image3.size.width, height:image3.size.height))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    class func getMixed4Img(image1: UIImage, image2: UIImage, image3: UIImage, image4: UIImage) -> UIImage {
        
        let size = CGSize(width:(image1.size.width + image2.size.width), height:(image1.size.height + image3.size.height))
        
        UIGraphicsBeginImageContext(size)
        
        image1.draw(in: CGRect(x:0, y:0, width:image1.size.width, height:image1.size.height))
        image2.draw(in: CGRect(x:image1.size.width, y:0, width:image2.size.width, height:image2.size.height))
        image3.draw(in: CGRect(x:0, y:(size.height/2), width:image3.size.width, height:image3.size.height))
        image4.draw(in: CGRect(x:(size.height/2), y:(size.height/2), width:image4.size.width, height:image4.size.height))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    // MARK: - GIF Animation extension
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        
        var delay = 0.01
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        
        var a = a
        var b = b
        
        // Check if one of them is nil
        
        if b == nil || a == nil {
            
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
            
        }
        
        // Swap for modulo
        if a! < b! {
            
            a! += b!
            b = a! - b!
            a! -= b!
            
        }
        
        // Get greatest common divisor
        var rest: Int
        
        while true {
            
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                
                a = b
                b = rest
            }
            
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        
        // Count number of images in gif
        
        let count = CGImageSourceGetCount(source)
        
        // Create two arrays to fill them with images
        
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays by images
        
        for i in 0..<count {
            
            // Creae image by every index
            
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // Add delay for every frame at its source
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            // Transform seconds to ms
            
            delays.append(Int(delaySeconds * 1000.0))
        }
        
        // Calculate full duration
        
        let duration: Int = {
            
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        
        // Get frames
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
            
        }
        
        
        // Animate image with array of images
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }

}
