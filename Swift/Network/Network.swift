//
//  Network.swift
//  Network
//
//  Created by 黄穆斌 on 16/9/22.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import Foundation

// MARK: - Type
extension Network {
    
    enum SessionType {
        case order
        case download
        case background
        case upload
    }
    
    struct Method {
        static let get: String = "GET"
        static let post: String = "POST"
        static let head: String = "HEAD"
        static let put: String = "PUT"
        static let delete: String = "DELETE"
        static let trace: String = "TRACE"
        static let options: String = "OPTIONS"
        static let connect: String = "CONNECT"
    }
}

// MARK: - Network

class Network: NSObject {
    
    // MARK: Datas
    
    var session: URLSession!
    var tasks = [Task]()
    var queue: OperationQueue!
    var operation: DispatchQueue!
    var type: Network.SessionType = .order
    // MARK: Init
    
    init(label: String, type: Network.SessionType) {
        super.init()
        self.type = type
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        operation = DispatchQueue(label: label)
        
        switch type {
        case .order:
            session = URLSession(configuration: URLSessionConfiguration.default)
        case .download:
            session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: queue)
        case .background:
            session = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: label), delegate: self, delegateQueue: queue)
        case .upload:
            session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: queue)
        }
    }
    
}


// MARK: - URLSession Delegate

extension Network: URLSessionDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        operation.async {
            if let identify = dataTask.taskDescription {
                if let index = self.tasks.index(where: { $0.identify == identify }) {
                    self.tasks[index].appendData(data: data)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        operation.async {
            if let identify = task.taskDescription {
                if let index = self.tasks.index(where: { $0.identify == identify }) {
                    self.tasks[index].callCompleted(error: error)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        operation.async {
            if let identify = downloadTask.taskDescription {
                if let index = self.tasks.index(where: { $0.identify == identify }) {
                    self.tasks[index].appendData(write: Int(bytesWritten), total: Int(totalBytesWritten))
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        fatalError("Myron.Network.urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64): Not to do.")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        operation.async {
            if let identify = downloadTask.taskDescription {
                if let index = self.tasks.index(where: { $0.identify == identify }) {
                    self.tasks[index].callFinishDownloading(location: location)
                }
            }
        }
    }
    
    
    /// 后台下载完成后的回调
    @objc(URLSessionDidFinishEventsForBackgroundURLSession:) func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        fatalError("Myron.Network.urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession): Not to do.")
    }
    
    /// 以及AppDeletgate
    //func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void)
}

// MARK: - Interface

extension Network {
    
    func order(identify: String? = nil, path: String, method: String = "GET", header: [String: String]? = nil, body: Data? = nil, time: TimeInterval? = nil) -> Network.Task? {
        return operation.sync {
            guard self.tasks.contains(where: { $0.identify == identify ?? path }) else { return nil }
            if let request = Network.request(path: path, method: method, header: header, body: body, time: time) {
                let order = self.session.dataTask(with: request)
                order.taskDescription = identify ?? path
                
                let task  = Network.Task(identify: identify ?? path, network: self, task: order)
                task.response.task = order
                self.tasks.append(task)
                
                return task
            }
            return nil
        }
    }
    
    func send(identify: String? = nil, path: String, method: String = "GET", header: [String: String]? = nil, body: Data? = nil, time: TimeInterval? = nil) -> Network.Task? {
        return operation.sync {
            //
            if let index = self.tasks.index(where: { $0.identify == identify ?? path }) {
                let task = self.tasks.remove(at: index)
                self.tasks.insert(task, at: 0)
                return task
            }
            
            //
            if let request = Network.request(path: path, method: method, header: header, body: body, time: time) {
                
                var action: URLSessionTask
                switch type {
                case .order, .download:
                    action = self.session.dataTask(with: request)
                case .background:
                    action = self.session.downloadTask(with: request)
                case .upload:
                    fatalError("Myron.Network.send: Can't use send in the upload type.")
                }
                action.taskDescription = identify ?? path
                
                let order = self.session.dataTask(with: request)
                order.taskDescription = identify ?? path
                
                let task  = Network.Task(identify: identify ?? path, network: self, task: order)
                task.response.task = order
                self.tasks.append(task)
                
                return task
            }
            return nil
        }
    }
    
}

extension Network {
    
    
}

extension Network {
    
    func task(identify: String) -> Network.Task? {
        return operation.sync {
            if let index = self.tasks.index(where: { $0.identify == identify }) {
                return self.tasks[index]
            }
            return nil
        }
    }
    
    fileprivate func removeTask(task: Network.Task) {
        if let index = self.tasks.index(where: { $0.identify == task.identify }) {
            self.tasks.remove(at: index)
        }
    }
    
}

// MAKR: - Request

extension Network {
    
    /// 创建 Request
    class func request(path: String,
                     method: String            = "GET",
                     header: [String: String]? = nil,
                       body: Data?             = nil,
                       time: TimeInterval?     = nil
        ) -> URLRequest? {
        
        guard let url = URL(string: path) else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = header
        request.timeoutInterval = time ?? 60
        
        return request
    }
    
}

// MARK: - Task

extension Network {
    public class Task {
        
        var identify: String
        weak var network: Network?
        var response: Network.Response
        
        var receive: ((_ response: Network.Response) -> Void)?
        var completed: ((_ response: Network.Response) -> Void)?
        var finishDownloading: ((_ response: Network.Response) -> Void)?
        
        init(identify: String, network: Network, task: URLSessionTask) {
            self.identify = identify
            self.network = network
            self.response = Network.Response()
            self.response.task = task
        }
        
        fileprivate func callCompleted(error: Error?) {
            response.error = error
            completed?(response)
            
            self.network?.removeTask(task: self)
            self.response.task = nil
            self.network = nil
        }
        
        fileprivate func appendData(data: Data) {
            response.append(data)
            receive?(response)
        }
        fileprivate func appendData(write: Int, total: Int) {
            response.count += write
            response.total = total
            receive?(response)
        }
        fileprivate func callFinishDownloading(location: URL) {
            response.url = location
            if finishDownloading == nil {
                response.data = try? Data(contentsOf: location)
            } else {
                finishDownloading?(response)
            }
        }
        
        func setCompleted(operation: @escaping (_ response: Network.Response) -> Void) -> Network.Task {
            completed = operation
            return self
        }
        func setReceive(operation: @escaping (_ response: Network.Response) -> Void) -> Network.Task {
            completed = operation
            return self
        }
        func setFinishDownloading(operation: @escaping (_ response: Network.Response) -> Void) -> Network.Task {
            finishDownloading = operation
            return self
        }
        
        // MARK:
        func resume() {
            network?.operation.async {
                self.response.task?.resume()
            }
        }
        
        func cancel() {
            network?.operation.async {
                self.response.task?.cancel()
                self.response.error = NSError(domain: self.identify, code: -200, userInfo: ["message": "User cancel"])
                self.completed?(self.response)
                self.network?.removeTask(task: self)
                self.response.task = nil
                self.network = nil
            }
        }
        
        func suspend() {
            network?.operation.async {
                self.response.task?.suspend()
            }
        }
        
    }
}

// MARK: - Response 

extension Network {
    public class Response {
        var data: Data?
        weak var task: URLSessionTask?
        var error: Error?
        var url: URL?
        
        private var _count: Int = 0
        var count: Int {
            set { _count = newValue }
            get {
                if data == nil {
                    return _count
                } else {
                    return data!.count
                }
            }
        }
        
        private var _totaol: Int = -1
        var total: Int {
            set { _totaol = newValue }
            get {
                return _totaol
            }
        }
        
        func append(_ data: Data) {
            if self.data == nil {
                self.data = data
            } else {
                self.data?.append(data)
            }
        }
    }
}
