// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//let ti: Double = Double(2.3477777777)
//let x: Double = fmod(ti, 1) * 100
//let y: Double = round(x)
//let centiseconds: Int = Int(round(fmod(ti, 1) * 100))

let interval = NSTimeInterval(18.777777777777777)
let ti: Double = Double(interval)
let minutes: Int = (Int(ti) / 60) % 60
let seconds: Int = Int(ti) % 60
let centiseconds: Int = Int(round(fmod(ti, 1) * 100))
var timeUnits: [String: Int] = ["minutes": minutes, "seconds": seconds, "centiseconds": centiseconds]