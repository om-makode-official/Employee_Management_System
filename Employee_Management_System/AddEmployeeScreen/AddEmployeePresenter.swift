//
//  AddEmployeePresenter.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation
import Combine
import UIKit

class AddEmployeePresenter: ObservableObject{
    
    
    @Published var showAlert = false
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var role: String = ""
    @Published var department: String = "Engineering"
    @Published var salary: String = ""
    @Published var joinDate: Date = Date()
//    @Published var joinDate:String = ""
    @Published var isSaving: Bool = false
    @Published var isValid: Bool = false
    @Published var identifier: String = "Add"
    @Published var openPickerSheet: Bool = false
    @Published var selectedImage: UIImage?
    @Published var imageUrl: String?
    @Published var alert: AlertResponse?
    
    let departments = ["Engineering", "Design", "Marketing", "Human Resources", "Sales", "Management"]
    private var cancellables = Set<AnyCancellable>()
    
    let router: AddEmployeeRouter
    let interactor: AddEmployeeInteractor
    var employee: EmployeeListModel?
    
    weak var delegate: ReloadData?
    weak var detailsDelegate: ReloadDetailsDelegateProtocol?
    
    init(router: AddEmployeeRouter,
         interactor: AddEmployeeInteractor,
         employee: EmployeeListModel?) {
        self.router = router
        self.interactor = interactor
        self.employee = employee
        
        
        if let employeeData = employee{
            self.identifier = "edit"
            self.name = employeeData.name ?? "NA"
            self.email = employeeData.email ?? "NA"
            self.phone = employeeData.phone ?? "NA"
            self.role = employeeData.role ?? "NA"
            self.department = employeeData.department ?? "NA"
            self.salary = employeeData.salary ?? "NA"
            
            self.joinDate = stringToDate(dateString: employeeData.joinDate ?? "NA")
            self.imageUrl = employeeData.imageUrl ?? "NA"
            
        }
    }
    func saveChanges(){
        saveImage()
//            if selectedImage != nil{
//                let imageUrl = saveImage()
//                print("img url-------------------------",imageUrl)
//            }else{
//                updateEmployee(imageUrl: "NA")
//            }
            
            
//        }else{
//            if selectedImage != nil{
//                let imageUrl = saveImage()
//                print("img url-------------------------",imageUrl)
//            }else{
//                saveEmployee(imageUrl: "NA")
//            }
//        }
    }
    
    func saveEmployee(imageUrl: String){
        self.isSaving = true
        
        let date = dateToString(date: joinDate)
        
        Task{
            do{
                guard let response = try await interactor.save(name: self.name,
                                                               email: self.email,
                                                               phone: self.phone,
                                                               role: self.role,
                                                               department: self.department,
                                                               salary: self.salary,
                                                               joinDate: date,
                                                               imageUrl: imageUrl)
                else{ return }
                
                await MainActor.run{
                    if response == true{
                        self.showSuccessAlert = true
                        self.isSaving = false
                    }
                }
            }catch let error{
                await MainActor.run{
                    print(error)
                }
            }
        }
    }
    func updateEmployee(imageUrl: String){
        self.isSaving = true
        let date = dateToString(date: joinDate)
        
        Task{
            do{
                let response = try await interactor.updateEmployee(name: self.name,
                                                                   email: self.email,
                                                                   phone: self.phone,
                                                                   role: self.role,
                                                                   department: self.department,
                                                                   salary: self.salary,
                                                                   joinDate: date,
                                                                   id: self.employee?.id,
                                                                   imageUrl: imageUrl)
                
                await MainActor.run{
                    if response.0 == true{
                        self.employee = response.1
                        self.showSuccessAlert = true
                        self.isSaving = false
                    }
                }
                
            }catch let error{
                print(error)
            }
        }
    }
    
    func saveImage(){
        if let image = self.selectedImage {
            Task{
                do{
                    let response = try await interactor.uploadImage(image: image)
                    await MainActor.run{
                        if self.identifier == "edit"{
                            updateEmployee(imageUrl: response)
                        }else{
                            saveEmployee(imageUrl: response)
                        }
                    }
                }catch let error{
                        print(error.localizedDescription)
                }
            }
        }
        else if imageUrl != nil{
            updateEmployee(imageUrl: imageUrl!)
        }
        else{
            saveEmployee(imageUrl: "NA")
        }
        
    }
    
    func deleteEmployee(){
        guard let emp = self.employee, let id = emp.id else{ return }
        Task{
            do{
                let response = try await interactor.deleteEmployee(id: id)
                
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    func dateToString(date: Date) -> String{
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func stringToDate(dateString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString){
            return date
        }
        return Date()
    }
    
    func reloadListScreen(){
        delegate?.getAllEmployees()
    }
    
    func reloadDetailsScreen(){
        if let data = self.employee{
            detailsDelegate?.reloadData(employee: data)
        }
    }
    
    func goToPreviousScreen(){
        router.goToBack()
    }
}
