//
//  EmployeeDetailPresenter.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation

class EmployeeDetailPresenter: ObservableObject, ReloadDetailsDelegateProtocol{
    
    @Published var employee: EmployeeListModel
    let profileColor: String
    let router: EmployeeDetailsRouter

    init(employee: EmployeeListModel, profileColor: String, router: EmployeeDetailsRouter) {
        self.employee = employee
        self.profileColor = profileColor
        self.router = router
    }
    
    func editEmployee(){
        router.openEditScreen(employee: self.employee, detailsDelegate: self)
    }
    
    func goToPreviousScreen(){
        router.goToPreviousScreen()
    }
    
    func reloadData(employee: EmployeeListModel) {
        self.employee = employee
    }
}
