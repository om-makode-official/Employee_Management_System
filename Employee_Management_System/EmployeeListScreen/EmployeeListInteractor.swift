//
//  EmployeeListInteractor.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation

class EmployeeListInteractor{
    
    
//    func save(name: String, email: String) async throws -> Bool?{
//
//        let urlString = "http://localhost:8081/api/users"
//
//        guard let url = URL(string: urlString) else { return nil }
//
//        var urlRequest = URLRequest(url: url)
//
//        urlRequest.httpMethod = "POST"
//
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: String] = [
//            "name": name,
//            "email": email
//        ]
//
//        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
//
//        let response = try await URLSession.shared.data(for: urlRequest)
//
//        guard let res = response.1 as? HTTPURLResponse else { return false }
//
//        if res.statusCode == 200{
//            return true
//        }
//        return false
//
//        print(response.1)
//    }
    
    func getAllEmployees() async throws -> [EmployeeListModel]{
        
        let urlString = "http://localhost:8081/api/users"
        
        guard let url = URL(string: urlString) else { return [] }
        
        let response = try await URLSession.shared.data(from: url)
        print(response.0)
        
        let data = try JSONDecoder().decode([EmployeeListModel].self, from: response.0)
        
        return data
        
    }
    
//    func getEmployeeById(id: Int) async throws -> EmployeeListModel?{
//         let urlString = "http://localhost:8081/api/users/\(id)"
//        print(urlString)
//
//        guard let url = URL(string: urlString) else{ return nil }
//
//        let response = try await URLSession.shared.data(from: url)
//        print(response.0)
//
//        let data = try JSONDecoder().decode(EmployeeListModel.self, from: response.0)
//        print(data)
//
//        return data
//    }
    
    
}
