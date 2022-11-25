//
//  LocationPickerView.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/24.
//

import Foundation
import LocationPicker
import SwiftUI

struct LocationPickerView: View, UIViewRepresentable {
    private var onPicked: (LocationItem) -> Void
    private static var locationPickerController: LocationPicker = .init()
    private var currentLocation: LocationItem?

    init(currentLocation: LocationItem?, onPicked: @escaping (LocationItem) -> Void) {
        self.onPicked = onPicked
        self.currentLocation = currentLocation
        LocationPickerView.locationPickerController.selectCompletion = onPicked
        LocationPickerView.locationPickerController.currentLocationIconColor = .systemBlue
        LocationPickerView.locationPickerController.searchResultLocationIconColor = .gray

        print("inited")
    }

    func makeUIView(context: Context) -> UIView {
        LocationPickerView.locationPickerController.searchBar.text = ""
        if currentLocation != nil {
            LocationPickerView.locationPickerController.selectLocationItem(currentLocation!)
        }
        let view = LocationPickerView.locationPickerController.view!
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        print("updating")
        uiView.updateConstraints()
    }
}
