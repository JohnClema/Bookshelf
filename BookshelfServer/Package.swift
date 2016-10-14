import PackageDescription

let package = Package(
    name: "BookshelfServer",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 0),
        .Package(url: "https://github.com/apple/swift-protobuf.git", Version(0,9,24)),
        ]
)
