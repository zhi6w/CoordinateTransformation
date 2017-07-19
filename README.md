# CoordinateTransformation
地球坐标(WGS84) 与 火星坐标(GCJ-02) 相互转换

> 在项目中导入框架
```swift
import MapKit
import CoordinateKit  // 坐标转换
```

> 地球坐标 -->> 火星坐标
```swift
let cgj02Coordinate = CoordinateTransformation.WGS84_To_CGJ02(coordinate: CLLocationCoordinate2D)
```

> 火星坐标 -->> 地球坐标
```swift
let wgs84Coordinate = CoordinateTransformation.CGJ02_To_WGS84(coordinate: CLLocationCoordinate2D)
```
