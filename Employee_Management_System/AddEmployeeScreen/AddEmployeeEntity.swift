//
//  AddEmployeeEntity.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/11/26.
//

import Foundation

enum AlertResponse: Identifiable{
    case success(title: String, message: String, onClick: () -> Void)
    
    var id: Int{
        switch self{
        case .success(_,_,_):
            return 0
        
        }
        
    }
}
