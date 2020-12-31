//
//  StorageManager.swift
//  Messenger1
//
//  Created by sang1 on 25/12/2020.
//

import Foundation
import FirebaseStorage
final class StorageManager {
    
    static let shared = StorageManager()
    private  let storage = Storage.storage().reference()
    
    /*
     /images/truongsangndc-gmail-com_profile_picture.png
     
     */
    public typealias UploadPictureCompletion =  (Result<String, Error>) -> Void
    ///upload picture to firebase and return url string to download
    public func uploadProfilepicture(with data: Data,
                                     fileName: String,
                                     completion:@escaping UploadPictureCompletion){
        storage.child("image\(fileName)").putData(data,metadata: nil,completion: { metadata , error in
            guard error == nil else {
          
            
            print("Failed to upload data to firebase for picture")
            completion(.failure(StorageErrors.failedToupload))
            return
            }
            self.storage.child("image\(fileName)").downloadURL(completion: { url , error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToupload))
                    
                    return
                }
                let urlString = url.absoluteString
                print("download url returned :\(urlString)")
                completion(.success(urlString))
            })
             
        })
    }
    
    public enum StorageErrors:Error {
        case failedToupload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result< URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion:  { url ,error in
            guard let url = url,error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        })
    }
}
