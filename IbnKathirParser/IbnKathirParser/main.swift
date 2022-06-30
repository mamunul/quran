
import Foundation

let basePath = "Documents/ios_workspace/htmlattributes/IbnKathirParser/IbnKathirParser/IbnKathirContents"
let homeDirectory = FileManager.default.homeDirectoryForCurrentUser

let folderUrl = homeDirectory.appendingPathComponent(basePath, isDirectory: true)
HTMLContentParser().execute(url: folderUrl)
