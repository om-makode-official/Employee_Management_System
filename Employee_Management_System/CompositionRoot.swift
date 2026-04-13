//
//  CompositionRoot.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/7/26.
//

import Foundation
import UIKit
import CoreData

class CompositionRoot{
    
    
    private lazy var navVC: UINavigationController = {
        let vc = UINavigationController.init()
        return vc
    }()
    
    func getNavVC() -> UIViewController{
        return navVC
    }
    
    func naviToFirstScreen(){
        let first = EmployeeListBuilder().createModule(navigateToAddEmployeeScreen, navigateToDetails)
        navVC.pushViewController(first, animated: true)
    }
    
    func navigateToDetails(_ employee: EmployeeListModel,
                           _ profileColor: String,
                           _ delegate: ReloadData){
        let details = EmployeeDetailsBuilder().createModule(employee, profileColor, popScreen, navigateToAddEmployeeScreen, delegate)
        navVC.pushViewController(details, animated: true)
    }

    func navigateToAddEmployeeScreen(_ delegate: ReloadData,_ employee: EmployeeListModel?, _ detailsDelegate: ReloadDetailsDelegateProtocol?){
        let vc = AddEmployeeBuilder().createModule(popScreen, delegate, employee, detailsDelegate)
        navVC.pushViewController(vc, animated: true)
    }
    
    func popScreen(){
        navVC.popViewController(animated: true)
    }
}
