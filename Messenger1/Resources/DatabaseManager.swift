//
//  DatabaseManager.swift
//  Messenger1
//
//  Created by sang1 on 20/12/2020.
//

import Foundation
import FirebaseDatabase
final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emaiAddress:String) -> String {
        var safeEmail = emaiAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
//Mark: -Account Management
extension DatabaseManager {
    public func userExists(with email:String,completion: @escaping ((Bool) -> Void) ) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
              completion(false)
                return
            }
            completion(true)
        })

    }
    
    
    ///Insert new user to database
    public func insertUser(with user: ChatAPpUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_namme": user.firstName,
            "last_name":user.lastName
        ] ,withCompletionBlock: { error, _ in
            guard error == nil else {
               print("failed to  write database")
                completion(false)
                return
            }
            completion(true)
            
        })
     
}
}
    struct ChatAPpUser {
        let firstName : String
        let lastName : String
        let emailAddress : String
        
        
        var safeEmail:String {
            
            var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
            
        }
        var profilePictureFileName : String {
            //truongsangndc-gmail-com_profile_picture.png
            return "\(safeEmail)_profile_picture.png"
        }
    
    }
