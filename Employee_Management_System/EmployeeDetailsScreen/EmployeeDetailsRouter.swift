//
//  EmployeeDetailsRouter.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation

class EmployeeDetailsRouter{
    let popScreen: () -> Void
    let navigateToAddEmployeeScreen: (_ delegate: ReloadData,
                                      _ employee: EmployeeListModel?,
                                      _ detailsDelegate: ReloadDetailsDelegateProtocol?) -> Void
    let delegate: ReloadData
    
    init(popScreen: @escaping () -> Void,
         navigateToAddEmployeeScreen: @escaping (_ delegate: ReloadData, _ employee: EmployeeListModel?, _ detailsDelegate: ReloadDetailsDelegateProtocol?) -> Void,
         delegate: ReloadData) {
        self.popScreen = popScreen
        self.navigateToAddEmployeeScreen = navigateToAddEmployeeScreen
        self.delegate = delegate
    }
    
    func goToPreviousScreen(){
        self.popScreen()
    }
    
    func openEditScreen(employee: EmployeeListModel, detailsDelegate: ReloadDetailsDelegateProtocol){
        self.navigateToAddEmployeeScreen(delegate, employee, detailsDelegate)
    }
    
}
