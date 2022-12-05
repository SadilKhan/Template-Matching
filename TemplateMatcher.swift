enum TemplateMatchingAlgorithm: String {
    case TM_SQDIFF = "Squared Difference"
    case TM_SQDIFF_NORMED = "Normed Squared Difference"
    case TM_CCORR = "Cross Correlation"
    case TM_CCORR_NORMED = "Normed Cross Correlation"
    case TM_CCOEFF = "Correlation Coefficient"
    case TM_CCOEFF_NORMED = "Normed Correlation Coefficient"
}

/// Class for template matching.
///
/// Currently the class has six algorithms inspired from listed template matching algorithms in OpenCV website.
class TemplateMatching {

    /// Normed Cross Correlation
    ///
    /// The normed cross correlation calculates the similarity between two matrices. The higher the more similar two matrices are. Max value is 1.0 and min is -1.0
    ///
    /// - Parameters:
    ///   - searchSpace: The searchspace of the image where template matching will check the similarity
    ///   - template: The template for matching
    /// - Returns: The similarity value between -1.0 and 1.0.
    func normedCrossCorrelation(searchSpace: inout [[Double]], template: inout [[Double]]) -> Double {
        let elemMulSum = crossCorrelation(searchSpace: &searchSpace, template: &template)
        let normSeachSpace = norm(searchSpace)
        let normTemplate = norm(template)
        let xCorrValue = elemMulSum / (normSeachSpace * normTemplate)
        return xCorrValue
    }

    /// Cross Correlation
    ///
    /// The  cross correlation calculates the similarity between two matrices. The higher the more similar two matrices are. Max value is infinity and min is -infinity
    ///
    /// - Parameters:
    ///   - searchSpace: The searchspace of the image where template matching will check the similarity
    ///   - template: The template for matching
    /// - Returns: The similarity value
    func crossCorrelation(searchSpace: inout [[Double]], template: inout [[Double]]) -> Double {
        precondition(searchSpace.count == template.count && searchSpace[0].count == template[0].count, "Search Space and Template must have same size")
        // Scale the image within [0,1]
        if getMaxArray(searchSpace) > 1.0 {
            searchSpace = scaleImageBy255(searchSpace)
        }
        if getMaxArray(template) > 1.0 {
            template = scaleImageBy255(template)
        }
        let elemMulSum = sum2DArray(multiply2DArray(searchSpace, template))
        return elemMulSum
    }

    /// Correlation Coefficient
    ///
    /// The  correlation coefficient calculates the similarity between two matrices. The higher the more similar two matrices are.
    ///
    /// - Parameters:
    ///   - searchSpace: The searchspace of the image where template matching will check the similarity
    ///   - template: The template for matching
    /// - Returns: The similarity value
    func corrCoef(searchSpace: inout [[Double]], template: inout [[Double]]) -> Double {
        precondition(searchSpace.count == template.count && searchSpace[0].count == template[0].count, "Search Space and Template must have same size")
        // Scale the image within [0,1]
        if getMaxArray(searchSpace) > 1.0 {
            searchSpace = scaleImageBy255(searchSpace)
        }
        if getMaxArray(template) > 1.0 {
            template = scaleImageBy255(template)
        }

        var meanDiffSearchSpace = getMeanDiffMatrix(searchSpace)
        var meanDiffTemplate = getMeanDiffMatrix(template)

        return crossCorrelation(searchSpace: &meanDiffSearchSpace, template: &meanDiffTemplate)

    }

    /// Normed Correlation Coefficient
    ///
    /// The  normed correlation coefficient calculates the similarity between two matrices. The higher the more similar two matrices are.
    ///
    /// - Parameters:
    ///   - searchSpace: The searchspace of the image where template matching will check the similarity
    ///   - template: The template for matching
    /// - Returns: The similarity value between [-1.0,1.0]
    func normedCorrCoef(searchSpace: inout [[Double]], template: inout [[Double]]) -> Double {
        // Scale the image within [0,1]
        let elementMul = corrCoef(searchSpace: &searchSpace, template: &template)
        let normMeanDiffSearchSpace = norm(getMeanDiffMatrix(searchSpace))
        let normMeanDiffTemplate = norm(getMeanDiffMatrix(template))

        return elementMul / (normMeanDiffTemplate * normMeanDiffSearchSpace)

    }
    /// Calculates Squared Difference between two matrices
    ///
    /// The  normed correlation coefficient calculates the similarity between two matrices. The higher the more similar two matrices are.
    ///
    /// - Parameters:
    ///   - searchSpace: The searchspace of the image where template matching will check the similarity
    ///   - template: The template for matching
    /// - Returns: The similarity value.
    func sqDiff(searchSpace: inout [[Double]], template: inout [[Double]]) -> Double {
        precondition(searchSpace.count == template.count && searchSpace[0].count == template[0].count, "Search Space and Template must have same size")
        // Scale the image within [0,1]
        if getMaxArray(searchSpace) > 1.0 {
            searchSpace = scaleImageBy255(searchSpace)
        }
        if getMaxArray(template) > 1.0 {
            template = scaleImageBy255(template)
        }

        let sqDiffScore: Double = zip(searchSpace.joined(), template.joined()).map { (a, b) in
            (a - b) * (a - b)
        }.reduce(0, +)
        return sqDiffScore
    }
    /// Calculates Normed Squared Difference between two matrices
    ///
    /// The  normed correlation coefficient calculates the similarity between two matrices. The higher the more similar two matrices are.
    ///
    /// - Parameters:
    ///   - searchSpace: The searchspace of the image where template matching will check the similarity
    ///   - template: The template for matching
    /// - Returns: The similarity value.
    func normedSqDiff(searchSpace: inout [[Double]], template: inout [[Double]]) -> Double {
        let sqDiffScore = sqDiff(searchSpace: &searchSpace, template: &template)
        let normSearchSpace = norm(searchSpace)
        let normTemplate = norm(template)
        return sqDiffScore / (normSearchSpace * normTemplate)
    }
}
