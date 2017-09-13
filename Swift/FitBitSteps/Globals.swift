//
//  Globals.swift
//  FitBit Steps
//
//  Created by Daniel Hsu on 7/18/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation

let authURL: String = "https://www.fitbit.com/oauth2/authorize"
let callbackURI: String = "mhStepTracker://oauth-callback"
let tokenURL: String = "https://api.fitbit.com/oauth2/token"
let clientSecret: String = "45d700afa2244b04fc30f26b205eeb8b"
let clientID: String = "228NRR"
let completeAuthURL: String = "\(authURL)?client_id=\(clientID)&response_type=token&scope=activity&redirect_uri=\(callbackURI)"
var fitbitAccessToken: String? // Move to KeyChain later
var fitbitUserId: String?
var fitbitTokenExpiresIn: Int = 0
