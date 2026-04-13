//
//  EmployeeDetailView.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation
import SwiftUI

// MARK: - Main Detail View
struct EmployeeDetailView: View {
    @StateObject var presenter: EmployeeDetailPresenter

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                ZStack(alignment: .bottom) {
                    HeaderCurveShape()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: presenter.profileColor).opacity(0.4),
                                         Color(hex: presenter.profileColor).opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                        .ignoresSafeArea(edges: .top)
                    
                    if let image = presenter.employee.imageUrl, image != "NA"{
                        AsyncImage(url: URL(string: image), content: { img in
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 130, height: 130)
                                .shadow(color: Color(hex: presenter.profileColor).opacity(0.3), radius: 15, x: 0, y: 10)
                                .overlay(
                                    img
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                )
                                
                                
                            
                        }, placeholder: {
                            placeholderProfile
                        })
                        .offset(y: 65)
                    }else{
                        placeholderProfile
                            .offset(y: 65)
                    }
                }
                .zIndex(1)
                
                Spacer().frame(height: 80)
                
                VStack(spacing: 8) {
                    Text(presenter.employee.name ?? "NA")
                        .font(.title.weight(.bold))
                        .foregroundColor(.primary)
                    
                    Text(presenter.employee.role ?? "NA")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(presenter.employee.department ?? "NA")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: presenter.profileColor).opacity(0.1))
                        .foregroundColor(Color(hex: presenter.profileColor))
                        .clipShape(Capsule())
                }

                VStack(spacing: 16) {
                    infoRowView(icon: "building.2.fill", title: "Department", value: presenter.employee.department ?? "NA")
                    infoRowView(icon: "envelope.fill", title: "Email", value: presenter.employee.email ?? "NA")
                    infoRowView(icon: "phone.fill", title: "Phone", value: presenter.employee.phone ?? "NA")
                    infoRowView(icon: "person.text.rectangle.fill", title: "Designation", value: presenter.employee.role ?? "NA")
                    infoRowView(icon: "indianrupeesign.circle.fill", title: "Salary", value: presenter.employee.salary ?? "NA")
                    infoRowView(icon: "calendar.badge.clock", title: "Joined", value: presenter.employee.joinDate ?? "NA")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                .padding(.top, 32)
                .padding(.bottom, 40)
                
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    presenter.goToPreviousScreen()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .bold()
                })
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    presenter.editEmployee()
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.black)
                        .bold()
                })
            }
        }
    }
    
    var placeholderProfile: some View{
        Circle()
            .fill(.white)
            .frame(width: 130, height: 130)
            .shadow(color: Color(hex: presenter.profileColor).opacity(0.3), radius: 15, x: 0, y: 10)
            .overlay(
                Circle()
                    .fill(Color(hex: presenter.profileColor).opacity(0.2))
                    .padding(6)
            )
            .overlay(
                Text(String(presenter.employee.name?.prefix(1) ?? "NA"))
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: presenter.profileColor))
            )
    }

    func infoRowView(icon: String, title: String, value: String) -> some View{
        VStack{
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(UIColor.tertiarySystemGroupedBackground))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            Divider()
                .padding(.leading, 60)
        }
    }
}
