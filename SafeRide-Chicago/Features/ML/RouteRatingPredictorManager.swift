//RouteRatingPredictor Manager
//tabular regression machine learning model
//predicts continuous val, user rating 1-5 rounded

import Foundation
import CoreML

final class RouteRatingPredictorManager {
    private let model: RouteRatingPredictor

    init?() {
        do {
            model = try RouteRatingPredictor(
                configuration: MLModelConfiguration()
            )
        } catch {
            print("Failed to load RouteRatingPredictor:", error)
            return nil
        }
    }

    func predictRating(
        prefStepFree: Bool,
        prefFewerCrossings: Bool,
        prefWellLit: Bool,
        prefSafeSpots: Bool,
        prefAvoidCrowds: Bool,
        routeAccessibility: Double,
        routeSidewalkQuality: Double,
        routeLighting: Double,
        routeSafeSpots: Int,
        routeCrowding: Double,
        obstacleCount: Int,
        travelTime: Double,
        turnCount: Int,
        distanceMeters: Double
    ) -> Double? {
        do {
            let prediction = try model.prediction(
                prefStepFree: prefStepFree ? 1 : 0,
                prefFewerCrossings: prefFewerCrossings ? 1 : 0,
                prefWellLit: prefWellLit ? 1 : 0,
                prefSafeSpots: prefSafeSpots ? 1 : 0,
                prefAvoidCrowds: prefAvoidCrowds ? 1 : 0,
                routeAccessibility: routeAccessibility,
                routeSidewalkQuality: routeSidewalkQuality,
                routeLighting: routeLighting,
                routeSafeSpots: Int64(routeSafeSpots),
                routeCrowding: routeCrowding,
                obstacleCount: Int64(obstacleCount),
                travelTime: travelTime,
                turnCount: Int64(turnCount),
                distanceMeters: Int64(distanceMeters)
            )

            // Keeps the displayed rating between 1.0 and 5.0
            return min(max(prediction.userRating, 1.0), 5.0)

        } catch {
            print("Prediction failed:", error)
            return nil
        }
        
       
    }
}
