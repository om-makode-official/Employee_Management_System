//
//  EmployeeListRouter.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation

class EmployeeListRouter{
    
    let navigateToAddEmployeeScreen: (_ delegate: ReloadData,
                                      _ employee: EmployeeListModel?,
                                      _ detailsDetegate: ReloadDetailsDelegateProtocol?) -> Void
    
    let navigateToDetails: (_ employee: EmployeeListModel,
                            _ profileColor: String,
                            _ delegate: ReloadData) -> Void
    
    init(navigateToAddEmployeeScreen: @escaping (_ delegate: ReloadData,
                                                 _ employee: EmployeeListModel?,
                                                 _ detailsDetegate: ReloadDetailsDelegateProtocol?) -> Void,
         navigateToDetails: @escaping (_ employee: EmployeeListModel,
                                       _ profileColor: String,
                                       _ delegate: ReloadData) -> Void) {
        self.navigateToAddEmployeeScreen = navigateToAddEmployeeScreen
        self.navigateToDetails = navigateToDetails
    }
    
    func navigateToAddEmployee(delegate: ReloadData){
        self.navigateToAddEmployeeScreen(delegate, nil, nil)
    }
    
    func openDetailsScreen(employee: EmployeeListModel, profileColor: String, delegate: ReloadData){
        self.navigateToDetails(employee, profileColor, delegate)
    }
}
