//
//  ChatViewController.swift
//  Messenger1
//
//  Created by sang1 on 24/12/2020.
//

import UIKit
import MessageKit
struct  message :MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    
}
struct sender : SenderType {
    var photoURL: String
    var senderId: String
    
    var displayName: String
}


class ChatViewController: MessagesViewController {
    private var messages = [message]()
    
    private let selfSender = sender(photoURL: "",
                                    senderId: "1",
                                    displayName: "Joe Smith")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello world message")))
        messages.append(message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello world message.Hello world message")))
        view.backgroundColor = .red
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        

    }
    
          
    
}
extension ChatViewController:MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
        
    }
    
    
}
