import Flutter
import Foundation
import Nbmap
import UIKit

public class SwiftNbMapsFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = NbMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/nb_maps_flutter")
        
        let channel = FlutterMethodChannel(
            name: "plugins.flutter.io/nb_maps_flutter",
            binaryMessenger: registrar.messenger()
        )
        
        let nextBillionChannel = FlutterMethodChannel(
            name: "plugins.flutter.io/nextbillion_init",
            binaryMessenger: registrar.messenger()
        )
        
        nextBillionChannel.setMethodCallHandler{ call, result in
            switch call.method {
            case "nextbillion/init_nextbillion":
                if let args = call.arguments as? [String: Any] {
                    if let token = args["accessKey"] as? String? {
                        NGLAccountManager.accessToken = token
                    }
                    
                    let libraryBundle = Bundle(for: SwiftNbMapsFlutterPlugin.self)
                   
                    let version = libraryBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "Unknown"
                    let buildNumber = libraryBundle.object(forInfoDictionaryKey: "CFBundleVersion") ?? "Unknown"
                 
                    let crossPlatformInfo: String = "Flutter-\(version)-\(buildNumber)"
                    NGLAccountManager.crossPlatformInfo = crossPlatformInfo
                }
                result(nil)
            case "nextbillion/get_access_key":
                if let token = NGLAccountManager.accessToken {
                    result(token)
                }
            case "nextbillion/set_access_key":
                if let args = call.arguments as? [String: Any] {
                    if let token = args["accessKey"] as? String? {
                        NGLAccountManager.accessToken = token
                    }
                }
                result(nil)
            case "nextbillion/get_base_uri":
                result(NGLAccountManager.apiBaseURL.absoluteString)
            case "nextbillion/set_base_uri":
                if let args = call.arguments as? [String: Any] {
                    if let baseUri = args["baseUri"] as? String? {
                        NGLAccountManager.setAPIBaseURL(URL(string: baseUri!)!)
                    }
                }
                result(nil)
            case "nextbillion/set_key_header_name":
                if let args = call.arguments as? [String: Any] {
                    if let apiKeyHeaderName = args["apiKeyHeaderName"] as? String? {
                        NGLAccountManager.apiKeyHeaderName = apiKeyHeaderName
                    }
                }
                result(nil)
            case "nextbillion/get_key_header_name":
                result(NGLAccountManager.apiKeyHeaderName)

            case "nextbillion/get_nb_id":
                 result(NGLAccountManager.nbId)
            case "nextbillion/get_user_id":
                 result(NGLAccountManager.userId)
            case "nextbillion/set_user_id":
                if let args = call.arguments as? [String: Any] {
                   if let userId = args["userId"] as? String? {
                      NGLAccountManager.userId = userId
                   }
                }
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
            
        }
        
        channel.setMethodCallHandler { methodCall, result in
            switch methodCall.method {
            case "setHttpHeaders":
                guard let arguments = methodCall.arguments as? [String: Any],
                      let headers = arguments["headers"] as? [String: String]
                else {
                    result(FlutterError(
                        code: "setHttpHeadersError",
                        message: "could not decode arguments",
                        details: nil
                    ))
                    result(nil)
                    return
                }
                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.httpAdditionalHeaders = headers // your headers here
                NGLNetworkConfiguration.sharedManager.sessionConfiguration = sessionConfig
                result(nil)
            case "installOfflineMapTiles":
                guard let arguments = methodCall.arguments as? [String: String] else { return }
                let tilesdb = arguments["tilesdb"]
                installOfflineMapTiles(registrar: registrar, tilesdb: tilesdb!)
                result(nil)
            case "downloadOfflineRegion":
                // Get download region arguments from caller
                guard let args = methodCall.arguments as? [String: Any],
                      let definitionDictionary = args["definition"] as? [String: Any],
                      let metadata = args["metadata"] as? [String: Any],
                      let defintion = OfflineRegionDefinition.fromDictionary(definitionDictionary),
                      let channelName = args["channelName"] as? String
                else {
                    print(
                        "downloadOfflineRegion unexpected arguments: \(String(describing: methodCall.arguments))"
                    )
                    result(nil)
                    return
                }
                // Prepare channel
                let channelHandler = OfflineChannelHandler(
                    messenger: registrar.messenger(),
                    channelName: channelName
                )
                OfflineManagerUtils.downloadRegion(
                    definition: defintion,
                    metadata: metadata,
                    result: result,
                    registrar: registrar,
                    channelHandler: channelHandler
                )
            case "setOfflineTileCountLimit":
                guard let arguments = methodCall.arguments as? [String: Any],
                      let limit = arguments["limit"] as? UInt64
                else {
                    result(FlutterError(
                        code: "SetOfflineTileCountLimitError",
                        message: "could not decode arguments",
                        details: nil
                    ))
                    return
                }
                OfflineManagerUtils.setOfflineTileCountLimit(result: result, maximumCount: limit)
            case "getListOfRegions":
                // Note: this does not download anything from internet, it only fetches data drom database
                OfflineManagerUtils.regionsList(result: result)
            case "deleteOfflineRegion":
                guard let args = methodCall.arguments as? [String: Any],
                      let id = args["id"] as? Int
                else {
                    result(nil)
                    return
                }
                OfflineManagerUtils.deleteRegion(result: result, id: id)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private static func getTilesUrl() -> URL {
        guard var cachesUrl = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first,
              let bundleId = Bundle.main
            .object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String
        else {
            fatalError("Could not get map tiles directory")
        }
        cachesUrl.appendPathComponent(bundleId)
        cachesUrl.appendPathComponent(".nbmaps")
        cachesUrl.appendPathComponent("cache.db")
        return cachesUrl
    }
    
    private static func installOfflineMapTiles(registrar: FlutterPluginRegistrar, tilesdb: String) {
        var tilesUrl = getTilesUrl()
        let bundlePath = getTilesDbPath(registrar: registrar, tilesdb: tilesdb)
        NSLog(
            "Cached tiles not found, copying from bundle... \(String(describing: bundlePath)) ==> \(tilesUrl)"
        )
        do {
            let parentDir = tilesUrl.deletingLastPathComponent()
            try FileManager.default.createDirectory(
                at: parentDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
            if FileManager.default.fileExists(atPath: tilesUrl.path) {
                try FileManager.default.removeItem(atPath: tilesUrl.path)
            }
            try FileManager.default.copyItem(atPath: bundlePath!, toPath: tilesUrl.path)
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try tilesUrl.setResourceValues(resourceValues)
        } catch {
            NSLog("Error copying bundled tiles: \(error)")
        }
    }
    
    private static func getTilesDbPath(registrar: FlutterPluginRegistrar,
                                       tilesdb: String) -> String?
    {
        if tilesdb.starts(with: "/") {
            return tilesdb
        } else {
            let key = registrar.lookupKey(forAsset: tilesdb)
            return Bundle.main.path(forResource: key, ofType: nil)
        }
    }
}
