//
//  API.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/21/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import Moya
import Timepiece
import SwiftyUserDefaults
import SwiftyJSON

enum API {
	
	case updateDeviceProfile(profile: DeviceProfile)
	
	case getUpcoming
	
	case getSurveyURL
	
	case getWeekBundles
	case getBundle(date: Date)
	
	case getScheduleBy(badge: String)
	case getScheduleFor(date: Date)
	
	case getLunchBy(badge: String)
	case getLunchFor(date: Date)
	
	case getEventBy(badge: String)
	case getEvents(categories: [String]?, filters: [String: String])
	case getEventsFor(date: Date)
	
}

extension API: TargetType {
	
	var baseURL: URL {
		if let serverUrl = Bundle.main.object(forInfoDictionaryKey: "KlApiUrl") as? String {
			return URL(string: serverUrl)!
		} else {
			return URL(string: "https://api.bbnknightlife.com/m/")!
		}
	}
	
	var path: String {
		switch self {
		case .updateDeviceProfile(_):
			return "device/profile"
			
		case .getUpcoming:
			return "upcoming"
			
		case .getSurveyURL:
			return "survey"
			
		case .getWeekBundles:
			return "bundle/week"
		case let .getBundle(date):
			return "bundle/\( date.year )/\( date.month )/\( date.day )"
			
		case let .getScheduleBy(badge):
			return "schedule/\( badge )"
		case let .getScheduleFor(date):
			return "schedule/\( date.year )/\( date.month )/\( date.day )"
			
		case let .getLunchBy(badge):
			return "lunch/\( badge )"
		case let .getLunchFor(date):
			return "lunch/\( date.year )/\( date.month )/\( date.day )"
			
		case let .getEventBy(badge):
			return "events/\( badge )"
		case .getEvents(_, _):
			return "events"
		case let .getEventsFor(date):
			return "events/\(date.year)/\(date.month)/\(date.day)"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .updateDeviceProfile(_):
			return .post
			
		default:
			return .get
		}
	}
	
	var sampleData: Data {
		switch self {
		default:
			return Data()
		}
	}
	
	var task: Task {
		switch self {
		case let .updateDeviceProfile(profile):
			return .requestJSONEncodable(profile.toJSON)
			
		case let .getEvents(categories, filters):
			var parameters: [String: String] = [:]
			
			if let categories = categories {
				parameters["categories"] = categories.joined(separator: ",")
			}
			
			// Formats filters in format: Key:Value,Key:Value
			parameters["filters"] = filters.map({ "\($0):\($1)" }).joined(separator: ",")
			
			return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
		
		default:
			return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		return [
			"Device": Defaults[.deviceId],
			"Version": (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "Unknown",
			"API": "3.0"
		];
	}
	
}
