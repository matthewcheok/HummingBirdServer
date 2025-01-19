import Hummingbird
import Logging

public protocol AppArguments {
  var hostname: String { get }
  var port: Int { get }
  var logLevel: Logger.Level? { get }
}

public func buildApplication(_ arguments: some AppArguments) async throws -> some ApplicationProtocol {
  let environment = Environment()
  let logger = {
    var logger = Logger(label: "App")
    logger.logLevel =
      arguments.logLevel ??
      environment.get("LOG_LEVEL").map { Logger.Level(rawValue: $0) ?? .info } ??
      .info
    return logger
  }()
  let router = buildRouter()
  let app = Application(
    router: router,
    configuration: .init(
      address: .hostname(arguments.hostname, port: arguments.port),
      serverName: "Todos"
    ),
    logger: logger
  )
  return app
}

typealias AppRequestContext = BasicRequestContext

func buildRouter() -> Router<AppRequestContext> {
  let router = Router(context: AppRequestContext.self)

  // Add middleware
  router.addMiddleware {
    // static files
    FileMiddleware("Public")

    // logging middleware
    LogRequestsMiddleware(.info)
  }

  // Add health endpoint
  router.get("/health") { _, _ -> HTTPResponse.Status in
    return .ok
  }

  router.get { _, _ -> String in
    return "testing"
  }

  return router
}
