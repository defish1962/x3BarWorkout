//
//  Settings.swift
//  X3BarWorkout
//
//  Created by David Fish on 12/7/19.
//  Copyright © 2019 David Fish. All rights reserved.
//

import Foundation
import SwiftUI

class UserOnboard: ObservableObject {

    @Published var onboardComplete: Bool = false
}

final class Settings: ObservableObject {

    @Published var loggedIn: Bool = false

  private enum Keys: String {
    case user = "current_user"
  }

  static var currentUser: User? {
    get {
      guard let data = UserDefaults.standard.data(forKey: Keys.user.rawValue) else {
        return nil
      }
      return try? JSONDecoder().decode(User.self, from: data)
    }
    set {
      if let data = try? JSONEncoder().encode(newValue) {
        UserDefaults.standard.set(data, forKey: Keys.user.rawValue)
      } else {
        UserDefaults.standard.removeObject(forKey: Keys.user.rawValue)
      }
      UserDefaults.standard.synchronize()
    }
  }
}

extension String {

    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isBlank: Bool {
        return self.trim.isEmpty
    }

    var isAlphanumeric: Bool {
        if self.count < 8 {
            return true
        }
        return !isBlank && rangeOfCharacter(from: .alphanumerics) != nil
//        let regex = "^[a-zA-Z0-9]$"
//        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
//        return predicate.evaluate(with:self)
    }

    var isValidEmail: Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with:self)
    }

    var isValidPhoneNo: Bool {

        let phoneCharacters = CharacterSet(charactersIn: "+0123456789").inverted
        let arrCharacters = self.components(separatedBy: phoneCharacters)
        return self == arrCharacters.joined(separator: "")
    }

    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[@$!%*#?&])[0-9a-zA-Z@$!%*#?&]{8,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with:self)
    }

    var isValidPhone: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{4,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }

    var isValidURL: Bool {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }

    var isValidBidValue: Bool {

        guard let doubleValue = Double(self) else { return false}
        if doubleValue < 0{
            return false
        }
        return true
    }

    var verifyURL: Bool {
        if let url  = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
