import Foundation
import Nbmap

class SourcePropertyConverter {
    class func interpretTileOptions(properties: [String: Any]) -> [NGLTileSourceOption: Any] {
        var options = [NGLTileSourceOption: Any]()

        if let bounds = properties["bounds"] as? [Double] {
            options[.coordinateBounds] =
            NSValue(nglCoordinateBounds: boundsFromArray(coordinates: bounds))
        }
        if let minzoom = properties["minzoom"] as? Double {
            options[.minimumZoomLevel] = minzoom
        }
        if let maxzoom = properties["maxzoom"] as? Double {
            options[.maximumZoomLevel] = maxzoom
        }
        if let tileSize = properties["tileSize"] as? Double {
            options[.tileSize] = Int(tileSize)
        }
        if let scheme = properties["scheme"] as? String {
            let system: NGLTileCoordinateSystem = (scheme == "tms" ? .TMS : .XYZ)
            options[.tileCoordinateSystem] = system.rawValue
        }
        return options
        // TODO: attribution not implemneted for IOS
    }

    class func buildRasterTileSource(identifier: String,
                                     properties: [String: Any]) -> NGLRasterTileSource?
    {
        if let rawUrl = properties["url"] as? String, let url = URL(string: rawUrl) {
            return NGLRasterTileSource(identifier: identifier, configurationURL: url)
        }
        if let tiles = properties["tiles"] as? [String] {
            let options = interpretTileOptions(properties: properties)
            return NGLRasterTileSource(
                identifier: identifier,
                tileURLTemplates: tiles,
                options: options
            )
        }
        return nil
    }

    class func buildVectorTileSource(identifier: String,
                                     properties: [String: Any]) -> NGLVectorTileSource?
    {
        if let rawUrl = properties["url"] as? String, let url = URL(string: rawUrl) {
            return NGLVectorTileSource(identifier: identifier, configurationURL: url)
        }
        if let tiles = properties["tiles"] as? [String] {
            return NGLVectorTileSource(
                identifier: identifier,
                tileURLTemplates: tiles,
                options: interpretTileOptions(properties: properties)
            )
        }
        return nil
    }

    class func buildRasterDemSource(identifier: String,
                                    properties: [String: Any]) -> NGLRasterDEMSource?
    {
        if let rawUrl = properties["url"] as? String, let url = URL(string: rawUrl) {
            return NGLRasterDEMSource(identifier: identifier, configurationURL: url)
        }
        if let tiles = properties["tiles"] as? [String] {
            return NGLRasterDEMSource(
                identifier: identifier,
                tileURLTemplates: tiles,
                options: interpretTileOptions(properties: properties)
            )
        }
        return nil
    }

    class func interpretShapeOptions(properties: [String: Any]) -> [NGLShapeSourceOption: Any] {
        var options = [NGLShapeSourceOption: Any]()

        if let maxzoom = properties["maxzoom"] as? Double {
            options[.maximumZoomLevel] = maxzoom
        }

        if let buffer = properties["buffer"] as? Double {
            options[.buffer] = buffer
        }
        if let tolerance = properties["tolerance"] as? Double {
            options[.simplificationTolerance] = tolerance
        }

        if let cluster = properties["cluster"] as? Bool {
            options[.clustered] = cluster
        }
        if let clusterRadius = properties["clusterRadius"] as? Double {
            options[.clusterRadius] = clusterRadius
        }
        if let clusterMaxZoom = properties["clusterMaxZoom"] as? Double {
            options[.maximumZoomLevelForClustering] = clusterMaxZoom
        }

        // TODO: clusterProperties not implemneted for IOS

        if let lineMetrics = properties["lineMetrics"] as? Bool {
            options[.lineDistanceMetrics] = lineMetrics
        }
        return options
    }

    class func buildShapeSource(identifier: String, properties: [String: Any]) -> NGLShapeSource? {
        let options = interpretShapeOptions(properties: properties)
        if let data = properties["data"] as? String, let url = URL(string: data) {
            return NGLShapeSource(identifier: identifier, url: url, options: options)
        }
        if let data = properties["data"] {
            do {
                let geoJsonData = try JSONSerialization.data(withJSONObject: data)
                let shape = try NGLShape(data: geoJsonData, encoding: String.Encoding.utf8.rawValue)
                return NGLShapeSource(identifier: identifier, shape: shape, options: options)
            } catch {}
        }
        return nil
    }

    class func buildImageSource(identifier: String, properties: [String: Any]) -> NGLImageSource? {
        if let rawUrl = properties["url"] as? String, let url = URL(string: rawUrl),
           let coordinates = properties["coordinates"] as? [[Double]]
        {
            return NGLImageSource(
                identifier: identifier,
                coordinateQuad: quadFromArray(coordinates: coordinates),
                url: url
            )
        }
        return nil
    }

    class func addShapeProperties(properties: [String: Any], source: NGLShapeSource) {
        do {
            if let data = properties["data"] as? String {
                let parsed = try NGLShape(
                    data: data.data(using: .utf8)!,
                    encoding: String.Encoding.utf8.rawValue
                )
                source.shape = parsed
            }
        } catch {}
    }

    class func quadFromArray(coordinates: [[Double]]) -> NGLCoordinateQuad {
        return NGLCoordinateQuad(
            topLeft: CLLocationCoordinate2D(
                latitude: coordinates[0][1],
                longitude: coordinates[0][0]
            ),
            bottomLeft: CLLocationCoordinate2D(
                latitude: coordinates[3][1],
                longitude: coordinates[3][0]
            ),
            bottomRight: CLLocationCoordinate2D(
                latitude: coordinates[2][1],
                longitude: coordinates[2][0]
            ),
            topRight: CLLocationCoordinate2D(
                latitude: coordinates[1][1],
                longitude: coordinates[1][0]
            )
        )
    }

    class func boundsFromArray(coordinates: [Double]) -> NGLCoordinateBounds {
        return NGLCoordinateBounds(
            sw: CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0]),
            ne: CLLocationCoordinate2D(latitude: coordinates[3], longitude: coordinates[2])
        )
    }
}
