import ArgumentParser
import Hummingbird
import Logging

@main
struct HummingbirdArguments: AsyncParsableCommand, AppArguments {
  @Option(name: .shortAndLong)
  var hostname: String = "0.0.0.0"

  @Option(name: .shortAndLong)
  var port: Int = 8_080

  @Option(name: .long)
  var logLevel: Logger.Level?

  @Option(name: .shortAndLong)
  var location: String = "" // Note: this is ignored

  @Option(name: .shortAndLong)
  var target: String = "" // Note: this is ignored

  func run() async throws {
    let app = try await buildApplication(self)
    try await app.runService()
  }
}

/// Extend `Logger.Level` so it can be used as an argument
#if hasFeature(RetroactiveAttribute)
  extension Logger.Level: @retroactive ExpressibleByArgument {}
#else
  extension Logger.Level: ExpressibleByArgument {}
#endif
