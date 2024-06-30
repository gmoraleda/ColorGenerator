import Foundation
import PackagePlugin

@main
struct ColorGenerator: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }

        let assetCatalogPath = target.sourceFiles(withSuffix: "xcassets")
            .compactMap { assetCatalog in
                assetCatalog.path.string
            }
            .first ?? ""

        let outputPath = context.pluginWorkDirectory.appending(["Colors.swift"])

        let invocation = PluginInvocation(catalogPath: assetCatalogPath, outputPath: outputPath.string)

        return try [
            .buildCommand(
                displayName: "Generate Color Constants",
                executable: context.tool(named: "ColorGeneratorExec").path,
                arguments: [invocation.encodedString()],
                inputFiles: [],
                outputFiles: []
            )
        ]
    }
}

struct PluginInvocation: Codable {
    let catalogPath: String
    let outputPath: String

    func encodedString() throws -> String {
        let data = try JSONEncoder().encode(self)
        return String(decoding: data, as: UTF8.self)
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension ColorGenerator: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target _: XcodeTarget) throws -> [PackagePlugin.Command] {
        let assetCatalogPath = context.xcodeProject.filePaths
            .filter { $0.string.hasSuffix("xcassets") }
            .map { $0.string }
            .first!

        let outputPath = context.pluginWorkDirectory.appending(["Colors.swift"])

        let invocation = PluginInvocation(catalogPath: assetCatalogPath, outputPath: outputPath.string)

        return try [
            .buildCommand(
                displayName: "Generate Color Constants",
                executable: context.tool(named: "ColorGeneratorExec").path,
                arguments: [invocation.encodedString()],
                outputFiles: [outputPath]
            )
        ]
    }
}
#endif
