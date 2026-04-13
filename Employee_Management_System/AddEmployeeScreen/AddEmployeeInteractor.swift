//
//  AddEmployeeInteractor.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation
import UIKit
import Alamofire

class AddEmployeeInteractor{
    
    func save(name: String,
              email: String,
              phone: String,
              role: String,
              department: String,
              salary: String,
              joinDate: String,
              imageUrl: String) async throws -> Bool?{
        
        let urlString = "http://localhost:8081/api/users"
        
        guard let url = URL(string: urlString) else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "name": name,
            "email": email,
            "phone": phone,
            "role": role,
            "department": department,
            "salary": salary,
            "joinDate": joinDate,
            "imageUrl": imageUrl
        ]
        
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let response = try await URLSession.shared.data(for: urlRequest)
        
        guard let res = response.1 as? HTTPURLResponse else { return false }
        
        if res.statusCode == 200{
            return true
        }
        print(response.1)
        return false

        
    }
    
    
    func updateEmployee(name: String,
                        email: String,
                        phone: String,
                        role: String,
                        department: String,
                        salary: String,
                        joinDate: String,
                        id: Int?,
                        imageUrl: String) async throws -> (Bool?, EmployeeListModel?){
        
        guard let employeeId = id else{ return (false, nil) }
        
        let urlString = "http://localhost:8081/api/users/\(employeeId)"
        
        guard let url = URL(string: urlString) else { return (nil, nil) }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PUT"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "name": name,
            "email": email,
            "phone": phone,
            "role": role,
            "department": department,
            "salary": salary,
            "joinDate": joinDate,
            "imageUrl": imageUrl
        ]
        print("imageUrl_______________", imageUrl)
        print("Body_______________",body)
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let response = try await URLSession.shared.data(for: urlRequest)
        
        guard let res = response.1 as? HTTPURLResponse else { return (false, nil) }
        
        if res.statusCode == 200{
            let data = try JSONDecoder().decode(EmployeeListModel.self, from: response.0)
            print("Response Data______________",data)
            return (true, data)
        }
        print(response.1)
        return (false, nil)
        
    }
    
    func deleteEmployee(id: Int) async throws -> Bool?{
        
        let urlString = "http://localhost:8081/api/users/\(id)"
        guard let url = URL(string: urlString) else { return false }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "DELETE"
        
        let response = try await URLSession.shared.data(for: urlRequest)
        
        guard let res = response.1 as? HTTPURLResponse else { return false }
        
        if res.statusCode == 200{
            return true
        }
        return false
        
    }
    
    
    
    
//    func createMultipartBody(
//        parameters: [String: String]?,
//        fileData: Data,
//        boundary: String,
//        fileName: String,
//        mimeType: String,
//        fieldName: String
//    ) -> Data {
//
//        var body = Data()
//
//        let lineBreak = "\r\n"
//
//        // Add parameters
//        if let parameters = parameters {
//            for (key, value) in parameters {
//                body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
//                body.append("\(value)\(lineBreak)".data(using: .utf8)!)
//            }
//        }
//
//        // Add file
//        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
//        body.append("Content-Type: \(mimeType)\(lineBreak + lineBreak)".data(using: .utf8)!)
//        body.append(fileData)
//        body.append(lineBreak.data(using: .utf8)!)
//
//        // Closing boundary
//        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
//
//        return body
//    }
//
//
//
//    func uploadImage(image: UIImage) async throws -> String {
//
//        let url = URL(string: "http://localhost:8080/api/users/upload")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        // Convert image
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            throw URLError(.badURL)
//        }
//
//        let body = createMultipartBody(
//            parameters: nil,
//            fileData: imageData,
//            boundary: boundary,
//            fileName: "profile.jpg",
//            mimeType: "image/jpeg",
//            fieldName: "file" //  MUST MATCH SPRING
//        )
//
//        request.httpBody = body
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//
//        // Backend returns URL as plain string
//        guard let imageUrl = String(data: data, encoding: .utf8) else {
//            throw URLError(.cannotDecodeContentData)
//        }
//
//        return imageUrl
//    }
    
    func uploadImage(image: UIImage) async throws -> String {
        
        let url = "http://localhost:8081/api/users/upload"
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badURL)
        }
        
        let res =  try await withCheckedThrowingContinuation { continuation in
            
            AF.upload(
                multipartFormData: { multipart in
                    
                    multipart.append(
                        imageData,
                        withName: "file",              //  MUST MATCH SPRING
                        fileName: "profile.jpg",
                        mimeType: "image/jpeg"
                    )
                    
                },
                to: url,
                method: .post
            )
            .validate() // checks status code 200...299
            .responseString { response in
                
                switch response.result {
                case .success(let imageUrl):
                    print("success")
                    continuation.resume(returning: imageUrl)
                    
                case .failure(let error):
                    print("fail")
                    continuation.resume(throwing: error)
                }
            }
        }
        print("res:+++++++++++++++++",res)
        return res
    }
}
