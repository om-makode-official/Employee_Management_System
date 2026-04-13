//
//  EmployeeListEntity.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation

struct EmployeeListModel: Codable{
    let id: Int?
    let name: String?
    let email: String?
    let phone: String?
    let role: String?
    let department: String?
    let salary: String?
    let joinDate: String?
    let imageUrl: String?
}

enum LoadingState{
    case idle
    case loading
    case loaded
    case error
}

