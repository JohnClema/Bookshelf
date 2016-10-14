import Vapor
import HTTP

let drop = Droplet()

var shelf = Shelf(name: "Horus Heresy",
                  books: [
                    Book(title: "Horus Rising", author: "Dan Abnett", numberOfPages: 412),
                    Book(title: "False Gods", author: "Graham McNeill", numberOfPages: 406),
                    Book(title: "Galaxy in Flames", author: "Ben Counter", numberOfPages: 407),
                    ]
)

var protobufResponse: Response {
    guard let protobuf = try? shelf.serializeProtobuf() else {
        return Response(status: .internalServerError)
    }
    return Response(status: .ok, headers: ["Content-Type": "application/octet-stream"], body: protobuf)
}

drop.get("shelf") { request in
    guard let accept = request.headers["Accept"], accept == "application/octet-stream" else {
        return Response(status: .badRequest)
    }
    return protobufResponse
}

func handle(protobuf bytes: Bytes?) -> Response {
    guard let bytes = bytes else {
        return Response(status: .badRequest)
    }
    guard let book = try? Book(protobufBytes: bytes) else {
        return Response(status: .badRequest)
    }
    if !shelf.books.contains(book) {
        shelf.books.append(book)
        return Response(status: .ok)
    } else {
        return Response(status: .badRequest)
    }
}

drop.post("book") { request in
    guard let contentType = request.headers["Content-Type"], contentType == "application/octet-stream" else {
        return Response(status: .badRequest)
    }
    return handle(protobuf: request.body.bytes)
}

drop.run()
