import Foundation
import VoxeetSDK
import WebRTC

typealias VTComfortNoiseLevel = ComfortNoiseLevel
typealias VTMediaEngineComfortNoiseLevel = MediaEngineComfortNoiseLevel

extension DTO {

    struct ComfortNoiseLevel: Codable {

        let noiseLevel: VTComfortNoiseLevel

        init(noiseLevel: VTComfortNoiseLevel) {
            self.noiseLevel = noiseLevel
        }

        init(from decoder: Decoder) throws {

            let container = try decoder.singleValueContainer()

            switch try container.decode(String.self) {
            case "default": noiseLevel = .default
            case "low": noiseLevel = .low
            case "medium": noiseLevel = .medium
            case "off": noiseLevel = .off
            default: throw EncoderError.decoderFailed()
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch noiseLevel {
            case .default: try container.encode("default")
            case .low: try container.encode("low")
            case .medium: try container.encode("medium")
            case .off: try container.encode("off")
            @unknown default: throw EncoderError.encoderFailed()
            }
        }

        func toSdkType() -> VTComfortNoiseLevel {
            return noiseLevel
        }
    }

    struct MediaEngineComfortNoiseLevel: Codable {
        
        let noiseLevel: VTMediaEngineComfortNoiseLevel
        
        init(noiseLevel: VTMediaEngineComfortNoiseLevel) {
            self.noiseLevel = noiseLevel
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.singleValueContainer()
            
            switch try container.decode(String.self) {
            case "default": noiseLevel = .default
            case "low": noiseLevel = .low
            case "medium": noiseLevel = .medium
            case "off": noiseLevel = .off
            default: throw EncoderError.decoderFailed()
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch noiseLevel {
            case .default: try container.encode("default")
            case .low: try container.encode("low")
            case .medium: try container.encode("medium")
            case .off: try container.encode("off")
            @unknown default: throw EncoderError.encoderFailed()
            }
        }
        
        func toSdkType() -> VTMediaEngineComfortNoiseLevel {
            return noiseLevel
        }
    }
    
}
