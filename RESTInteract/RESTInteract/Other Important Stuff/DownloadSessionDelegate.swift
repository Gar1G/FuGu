//
//  DownloadSessionDelegate.swift
//  RESTInteract
//
//  Created by Akshay  on 16/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import Foundation

typealias CompleteHandlerBlock = () -> ()

class DownloadSessionDelegate: NSObject, URLSessionDelegate, URLSessionDownloadDelegate{
    
    static var shared = DownloadSessionDelegate()
    
    var session: URLSession{
        get{
            let config = URLSessionConfiguration.background(withIdentifier: "backgroundFetch")
            return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        }
    }
    
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("session error: \(error?.localizedDescription)")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("session \(session) has finished download task \(downloadTask) of URL \(location)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("session \(session) download task \(downloadTask) wrote an additional \(bytesWritten) out of an expected \(totalBytesWritten)")
        
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("background session \(session) finished events.")
    }
    
    
}
