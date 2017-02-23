import Foundation
import Kitura
import LoggerAPI
import Configuration

import SwiftMetrics
import SwiftMetricsDash
import SwiftMetricsBluemix

public class GeneratedApplication {
    public let router: Router
    private let manager: ConfigurationManager
    private let factory: AdapterFactory

    public init(configURL: URL) throws {
        router = Router()
        manager = try ConfigurationManager()
                          .load(url: configURL)
                          .load(.environmentVariables)
        // Set up monitoring
        let sm = try SwiftMetrics()
        let _ = try SwiftMetricsDash(swiftMetricsInstance : sm, endpoint: router)
    let _ = AutoScalar(swiftMetricsInstance: sm)

        factory = AdapterFactory(manager: manager)

        // Host swagger definition
        router.get("/explorer/swagger.yml") { request, response, next in
            // TODO(tunniclm): Should probably just pass the root into init()
            let projectRootURL = configURL.deletingLastPathComponent()
            let swaggerFileURL = projectRootURL.appendingPathComponent("definitions")
                                               .appendingPathComponent("todolist.yaml")
            do {
                try response.send(fileName: swaggerFileURL.path).end()
            } catch {
                Log.error("Failed to serve OpenAPI Swagger definition from \(swaggerFileURL.path)")
            }
        }

        try TodoResource(factory: factory).setupRoutes(router: router)
    }
}
