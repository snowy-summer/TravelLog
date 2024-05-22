//
//  ImageFileManager.swift
//  TripLog
//
//  Created by 최승범 on 2024/05/02.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()
    
    func saveImage(image: UIImage?) -> String {
        guard let image = image,
              let data = image.jpegData(compressionQuality: 1) else { return "" }
        
        if let directory =  FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).first {
            let fileName = "\(UUID().uuidString)"
            let fileUrl = directory.appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileUrl)
                return fileUrl.path
            } catch {
                print(FileManagerError.cantSaveImage.description)
                print("\(error)")
            }
                                                           
        }
        
        return ""
        
    }
    
    func deleteFile(path: String?) {
        guard let path = path else { return }
        
        let fileManager = FileManager.default
        
        do {
            if fileManager.fileExists(atPath: path) {
                try fileManager.removeItem(atPath: path)
            }
        } catch {
            print(FileManagerError.failToDelete.description)
            print("\(error)")
        }
    }
    
}
