//
//  AddEmployeeBuilder.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation
import UIKit
import SwiftUI

class AddEmployeeBuilder{
    func createModule(_ popScreen: @escaping () -> Void,
                      _ delegate: ReloadData,
                      _ employee: EmployeeListModel?,
                      _ detailsDelegate: ReloadDetailsDelegateProtocol?) -> UIViewController{
        
        let router = AddEmployeeRouter(popScreen: popScreen)
        let interactor = AddEmployeeInteractor()
        let presenter = AddEmployeePresenter(router: router, interactor: interactor, employee: employee)
        presenter.delegate = delegate
        presenter.detailsDelegate = detailsDelegate
        let view = AddEmployeeView(presenter: presenter)
        return UIHostingController(rootView: view)
    }
}

