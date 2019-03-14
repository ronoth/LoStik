//
//  CommandType.swift
//  LoStik
//
//  Created by Alsey Coleman Miller on 3/14/19.
//

import Foundation

public enum CommandType: String {
    
    /**
     Issues system level behavior actions, gathers status information on the firmware and hardware version, or accesses the module user EEPROM memory.
     */
    case system = "sys"
    
    /**
     Issues LoRaWAN protocol network communication behaviors, actions and configurations commands.
     */
    case mac = "mac"
    
    /**
     Issues radio specific configurations, directly accessing and updating the transceiver setup.
     */
    case radio = "radio"
}
