//
//  TIPSResponse.swift
//  TIPSKit
//
//  Created by James Blasius on 4/29/25.
//

import Foundation

public enum TIPSResponse {
    case summary([TIPSSummary])
    case detail([TIPSDetail])
}
