//
//  EmployeeDetailsBuilder.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation
import UIKit
import SwiftUI

class EmployeeDetailsBuilder{
    func createModule(_ employee: EmployeeListModel,
                      _ profileColor: String,
                      _ popScreen: @escaping () -> Void,
                      _ navigateToAddEmployeeScreen: @escaping (_ delegate: ReloadData,
                                                                _ employee: EmployeeListModel?,
                                                                _ detailsDelegate: ReloadDetailsDelegateProtocol?) -> Void,
                      _ delegate: ReloadData) -> UIViewController{
        
        let router = EmployeeDetailsRouter(popScreen: popScreen, navigateToAddEmployeeScreen: navigateToAddEmployeeScreen, delegate: delegate)
        let presenter = EmployeeDetailPresenter(employee: employee, profileColor: profileColor, router: router)
        let view = EmployeeDetailView(presenter: presenter)
        return UIHostingController(rootView: view)
    }
}
