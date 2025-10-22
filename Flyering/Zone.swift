import CoreLocation

struct Zone: Decodable, Identifiable {
    let id: Int
    let name: String
    let vertices: [CLLocationCoordinate2D]
    let labelLocation: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case id, name, vertices
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let rawVertices = try container.decode([[Double]].self, forKey: .vertices)
        var vertices = [CLLocationCoordinate2D]()
        for rawVertex in rawVertices {
            vertices.append(.init(latitude: rawVertex[0], longitude: rawVertex[1]))
        }
        self.vertices = vertices
        labelLocation = polygonCentroid(vertices: vertices)
    }
}

func polygonCentroid(vertices: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
    var area: Double = 0
    var centroidLatitude: Double = 0
    var centroidLongitude: Double = 0
    let n = vertices.count
    
    for i in 0..<n {
        let current = vertices[i]
        let next = vertices[(i + 1) % n]
        
        let factor = (current.latitude * next.longitude - next.latitude * current.longitude)
        area += factor
        centroidLatitude += (current.latitude + next.latitude) * factor
        centroidLongitude += (current.longitude + next.longitude) * factor
    }
    
    area /= 2.0
    let scale = 1 / (6 * area)
    
    centroidLatitude *= scale
    centroidLongitude *= scale
    
    return CLLocationCoordinate2D(latitude: centroidLatitude, longitude: centroidLongitude)
}
