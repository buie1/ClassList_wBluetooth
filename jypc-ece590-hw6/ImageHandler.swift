//
//  ImageHandler.swift
//  jypc-ece590-hw6
//
//  Created by Colby Stanley on 10/29/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit

//This class contains methods for compressing and decompressing UIImages
class ImageHandler{
    //Compresses a image into a 64 bit string
    func compressImage(pic: UIImage) -> String{
        let imageData:Data = UIImagePNGRepresentation(pic)!
        let imageString:String = imageData.base64EncodedString()
        return imageString
    }
    
    //Decompresses a 64 bit string into UIImage
    func decodeImage(compressedData: String) -> UIImage{
        let decodedData:Data = Data(base64Encoded: compressedData, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        let image:UIImage = UIImage(data: decodedData)!
        return image
    }
    
}
