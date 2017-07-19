//
//  CoordinateTransformation.swift
//  CoordinateTransformation
//
//  Created by zhi zhou on 2017/7/19.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit
import MapKit

/** 坐标标准转换 */
open class CoordinateTransformation: NSObject {

    static let a: Double = 6378245.0
    static let ee: Double = 0.00669342162296594323
    
    
    private override init() {
        super.init()
    }
    
    
    /// 坐标是否在境外
    open class func isOutOfChina(coordinate: CLLocationCoordinate2D) -> Bool {
        if coordinate.longitude < 72.004 || coordinate.longitude > 137.8347 {
            return true
        }
        
        if coordinate.latitude < 0.8293 || coordinate.latitude > 55.8271 {
            return true
        }
        
        return false
    }
    
    
    // MARK:- 坐标转换
    
    /// "地球坐标（国际标准-WGS84）" -->> "火星坐标（GCJ-02 国测局坐标系）"
    open class func WGS84_To_CGJ02(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if isOutOfChina(coordinate: coordinate) {
            return coordinate
        }
        
        var dLat: Double = transformLat(x: coordinate.longitude - 105.0, y: coordinate.latitude - 35.0)
        var dLon: Double = transformLon(x: coordinate.longitude - 105.0, y: coordinate.latitude - 35.0)
        
        let radLat = coordinate.latitude / 180.0 * .pi
        
        var magic = sin(radLat)
        magic = 1 - ee * magic * magic
        
        let sqrtMagic = sqrt(magic)
        
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * .pi)
        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * .pi)
        
        let cgj02Lat: CLLocationDegrees = coordinate.latitude + dLat
        let cgj02Lon: CLLocationDegrees = coordinate.longitude + dLon
        
        return CLLocationCoordinate2D(latitude: cgj02Lat, longitude: cgj02Lon)
    }
    
    /// "火星坐标（GCJ-02 国测局坐标系）" -->> "地球坐标（国际标准-WGS84）"
    open class func CGJ02_To_WGS84(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        if isOutOfChina(coordinate: coordinate) {
            return coordinate
        }
        
        var dLat: Double = transformLat(x: coordinate.longitude - 105.0, y: coordinate.latitude - 35.0)
        var dLon: Double = transformLon(x: coordinate.longitude - 105.0, y: coordinate.latitude - 35.0)
        
        let radLat = coordinate.latitude / 180.0 * .pi
        
        var magic = sin(radLat)
        magic = 1 - ee * magic * magic
        
        let sqrtMagic = sqrt(magic)
        
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * .pi)
        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * .pi)
        
        let wgs84Lat: CLLocationDegrees = coordinate.latitude * 2 - (coordinate.latitude + dLat)
        let wgs84Lon: CLLocationDegrees = coordinate.longitude * 2 - (coordinate.longitude + dLon)
        
        return CLLocationCoordinate2D(latitude: wgs84Lat, longitude: wgs84Lon)
    }
    
    
    class func transformLat(x: Double, y: Double) -> Double {
        var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x))
        ret += (20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0
        ret += (20.0 * sin(y * .pi) + 40.0 * sin(y / 3.0 * .pi)) * 2.0 / 3.0
        ret += (160.0 * sin(y / 12.0 * .pi) + 320 * sin(y * .pi / 30.0)) * 2.0 / 3.0
        
        return ret
    }
    
    class func transformLon(x: Double, y: Double) -> Double {
        var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x))
        ret += (20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0
        ret += (20.0 * sin(x * .pi) + 40.0 * sin(x / 3.0 * .pi)) * 2.0 / 3.0
        ret += (150.0 * sin(x / 12.0 * .pi) + 300.0 * sin(x / 30.0 * .pi)) * 2.0 / 3.0
        
        return ret
    }
    
}

