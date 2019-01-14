//
//  CLIUtilities.swift
//  SimpleCLI
//
//  Created by Felix Lapalme on 2018-11-18.
//  Copyright © 2018 Felix Lapalme. All rights reserved.
//

import Foundation

public enum ArgumentType {
    case keyOnly
    case keyAndValue
    case valueOnly
}

public struct Argument {
    let longName: String
    let shortName: String?
    let type: ArgumentType
    let defaultValue: String?
    let obligatory: Bool
    let description: String?
    let inputName: String?

    public init(longName: String,
         shortName: String? = nil,
         type: ArgumentType = .keyAndValue,
         defaultValue: String? = nil,
         obligatory: Bool = false,
         description: String? = nil,
         inputName: String? = nil) {
        self.longName = longName
        self.shortName = shortName
        self.type = type
        self.defaultValue = defaultValue
        self.obligatory = obligatory
        self.description = description
        self.inputName = inputName
    }
}

open class SimpleCLI {
    enum ProcessingError: Error {
        case requiredKeyHasNoValue(key: String)
        case unexpectedValueWithoutKey(value: String)
        case unexpectedArgument(key: String)
        case unknownArgument(key: String)
    }

    let configuration : [Argument]
    let singleValueArgument : Argument?

    public init(configuration config: [Argument]) {
        let singleValueArgumentArray = config.filter({$0.type == .valueOnly})
        if (singleValueArgumentArray.count > 1) {
            print("Error: Too many single value arguments")
        }
        
        singleValueArgument = singleValueArgumentArray.first
        
        configuration = config
    }

    public func parseArgs(_ args: [String]) -> Dictionary<String, String> {
        do {
            return try parseArguments(args)
        } catch {
            // print the automatically generated help
            print(error)
            print(self.helpString(args))
            return [:]
        }
    }
    
    public func helpString(_ args: [String]) -> String {
        let executableName = URL.init(fileURLWithPath: args[0]).lastPathComponent
        var helpString = "Usage: \(executableName)"
        for argument in configuration {
            var string = ""

            switch (argument.type) {
                case .keyAndValue: 
                    string.append("--\(argument.longName)")
                    if let inputName = argument.inputName {
                        string.append(" <\(inputName)>")
                    } else {
                        string.append(" <value>")
                    }

                case .keyOnly:
                    var keyString = argument.longName
                    if let shortName = argument.shortName {
                        keyString.append(" | -\(shortName)")
                    }
                    string.append("--\(keyString)")
                    
                case .valueOnly:
                    if let inputName = argument.inputName {
                        string.append("\(inputName)")
                    } else {
                        string.append("<value>")
                    }
            }

            if (!argument.obligatory) {
                string = " [\(string)]"
            }
            else {
                string = " \(string)"
            }

            helpString.append(string)
        }

        return helpString
    }

    func parseArguments(_ args: [String]) throws -> Dictionary<String, String> {
        var dictionary : Dictionary<String, String> = [:]
        var currentArgument : Argument?

        for arg in args.dropFirst() {
            let isLongKey = arg.starts(with: "--")
            let isShortKey = !isLongKey && arg.starts(with: "-")

            var newArgument: Argument?
            
            if isLongKey || isShortKey {
                guard let argument = configuration.first(where: {
                        if (isLongKey) {
                            let key = arg.dropFirst(2)
                            if ($0.longName == key) {
                                return true
                            }
                        } else if (isShortKey) {
                            guard let shortName = $0.shortName else {
                                return false
                            }

                            let key = arg.dropFirst(1)
                            if (shortName == key) {
                                return true
                            }
                        }

                        return false
                    })
                else {
                    throw ProcessingError.unknownArgument(key: arg)
                }

                newArgument = argument
            }
            else if let currentArgument = currentArgument {
                // it's a value
                do {
                    if let value = try process(argument: currentArgument) {
                        dictionary[currentArgument.longName] = value
                    }
                }
                catch {
                    throw error
                }
            }
            else if let singleValueArgument = singleValueArgument {
                if (dictionary[singleValueArgument.longName] == nil) {
                    dictionary[singleValueArgument.longName] = arg
                }
                else {
                    throw ProcessingError.unexpectedValueWithoutKey(value: arg)
                }
            }
            else {
                throw ProcessingError.unexpectedValueWithoutKey(value: arg)
            }

            if let currentArgument = currentArgument {
                // We have a previous argument with no value. Let's process it.
                do {
                    if let value = try process(argument: currentArgument) {
                        dictionary[currentArgument.longName] = value
                    }
                }
                catch {
                    throw error
                }
            }

            if (newArgument?.type != .keyOnly) {
                currentArgument = newArgument
            } else if let newArgument = newArgument {
                do {
                    if let value = try process(argument: newArgument) {
                        dictionary[newArgument.longName] = value
                    }
                }
                catch {
                    throw error
                }
            }
        }

        return dictionary
    }

    func process(argument: Argument, value: String? = nil) throws -> String? {
        if let value = value {
            return value
        }

        if (argument.type == .keyOnly) {
            return String(true)
        }

        if let defaultValue = argument.defaultValue {
            return defaultValue
        }

        if (argument.obligatory) {
            throw ProcessingError.requiredKeyHasNoValue(key: argument.longName)
        }
        else {
            return nil
        }
    }
}
