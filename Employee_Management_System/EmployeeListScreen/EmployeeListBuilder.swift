//
//  EmployeeListBuilder.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation

import Foundation
import UIKit
import SwiftUI

class EmployeeListBuilder{
    func createModule(_ navigateToAddEmployeeScreen: @escaping (_ delegate: ReloadData,
                                                                _ employee: EmployeeListModel?,
                                                                _ detailsDetegate: ReloadDetailsDelegateProtocol?) -> Void,
                      _ navigateToDetails: @escaping (_ employee: EmployeeListModel,
                                                      _ profileColor: String,
                                                      _ delegate: ReloadData) -> Void) -> UIViewController{
        
        let router = EmployeeListRouter(navigateToAddEmployeeScreen: navigateToAddEmployeeScreen, navigateToDetails: navigateToDetails)
        
        let interactor = EmployeeListInteractor()
        let presenter = EmployeeListPresenter(interactor: interactor, router: router)
        let vc = EmployeeListView(presenter: presenter)
        return UIHostingController(rootView: vc)
    }
}
