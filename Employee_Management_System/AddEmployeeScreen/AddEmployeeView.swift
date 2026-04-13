//
//  AddEmployeeView.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation
import SwiftUI
//import Combine

struct AddEmployeeView: View {
    
    @StateObject var presenter: AddEmployeePresenter
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    Button(action: {
                        presenter.openPickerSheet = true
                    }, label: {
                        if let image = presenter.selectedImage{
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        }else if let imageUrl = presenter.imageUrl{
                            AsyncImage(url: URL(string: imageUrl), content: { img in
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            }, placeholder: {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 150, height: 150)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                }
                                .padding(.top, 16)
                            })
                        }else{
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 150, height: 150)
                                
                                Image(systemName: "camera.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 16)
                        }
                    })
                    
                    sectionCard(title: "Personal Information")
                    
                    sectionCard2(title: "Professional Details")
                    
                    Button(action: {
                        presenter.saveChanges()
                    }) {
                        HStack {
                            if presenter.isSaving {
                                ProgressView()
                            }
                            Text(presenter.identifier == "edit"
                                 ? presenter.isSaving ? "Saving..." : "Update Employee"
                                 : presenter.isSaving ? "Saving..." : "Create Employee")
                            .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.blue.opacity(0.3), radius: 8)
                    }
                    .padding(.top, 16)
                    
                    if presenter.identifier == "edit"{
                        Button(action: {
                            presenter.deleteEmployee()
                        }) {
                            HStack {
                                if presenter.isSaving {
                                    ProgressView()
                                }
                                Text(presenter.isSaving ? "Saving..." : "Delete Employee")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.red.opacity(0.3), radius: 8)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(presenter.identifier == "edit" ? "Edit Employee" : "Add Employee")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presenter.goToPreviousScreen()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .bold()
                })
            }
        }
        .sheet(isPresented: $presenter.openPickerSheet, content: {
            ImagePicker(selectedImage: $presenter.selectedImage)
        })
        .alert(item: $presenter.alert, content: { alert in
            self.alertView(alert)
        })
        
        
        //            .alert("Success", isPresented: $presenter.showAlert) {
        //                Button("OK") {
//                            if presenter.identifier == "edit"{
//                                presenter.reloadListScreen()
//                                presenter.reloadDetailsScreen()
//                                presenter.goToPreviousScreen()
//                            }else{
//                                presenter.reloadListScreen()
//                                presenter.goToPreviousScreen()
//                            }
        //
        //                }} message: {
        //                Text("Employee has been successfully added to the system.")
        //            }
        
        
    }
    
    private func alertView(_ alert: AlertResponse) -> Alert{
        switch alert{
            
        case .success(let title, let message, let onClick):
            return Alert(title: Text(title),
                         message: Text(message),
                         dismissButton: .default(Text("OK")){
                onClick()
            })
            
       
            
            
        }
    }
        
        func sectionCard(title: String) -> some View{
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
                
                VStack(spacing: 8) {
                    inputField(icon: "person.fill", placeholder: "Full Name", text: $presenter.name)
                    Divider()
                    inputField(icon: "envelope.fill", placeholder: "Email Address", text: $presenter.email)
                    Divider()
                    inputField(icon: "phone.fill", placeholder: "Phone Number", text: $presenter.phone)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                )
            }
        }
        
        @ViewBuilder
        func sectionCard2(title: String) -> some View{
            
            
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
                
                VStack(spacing: 8) {
                    inputField(icon: "briefcase.fill", placeholder: "Job Role", text: $presenter.role)
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.gray)
                            .frame(width: 24)
                        Picker("Department", selection: $presenter.department) {
                            ForEach(presenter.departments, id: \.self) { dept in
                                Text(dept).tag(dept)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.primary)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    inputField(icon: "indianrupeesign.circle.fill", placeholder: "Annual Salary", text: $presenter.salary)
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                            .frame(width: 24)
                        DatePicker("Joining Date", selection: $presenter.joinDate, displayedComponents: .date)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                        .shadow(color: Color.black.opacity(0.03), radius: 5)
                )
            }
        }
        
        func inputField(icon: String, placeholder: String, text: Binding<String>) -> some View{
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 24)
                
                TextField(placeholder, text: text)
                    .autocorrectionDisabled()
            }
            .padding(.vertical, 8)
        }
    }
