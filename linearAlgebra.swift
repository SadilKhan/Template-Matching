import Foundation


/// Element-wise Multiplication of 2d Matrices
/// - Parameters:
///   - array1: Matrix of shape (W,H)
///   - array2: Matrix of shape (W,H)
/// - Returns: A 2d Matrix resulting from a pointwise matrix multiplication
func multiply2DArray(_ array1: [[Double]], _ array2: [[Double]]) -> [[Double]] {
    zip(array1, array2).map { (vector1, vector2) in
        zip(vector1, vector2).map { (value1, value2) in
            value1 * value2
        }
    }
}

/// Sum of all elements of 2d matrices
/// - Parameters:
///   - arr: The matrix of shape (W,H)
///   - initResult: The initial sum with which the elements in the matrices are added.
/// - Returns: Returns a double value of sum of all elements
func sum2DArray(_ arr: [[Double]], _ initResult: Double = 0) -> Double {
    return arr.joined().reduce(initResult, +)
}

/**
 Calculates the norm of a matrix
 
 The norm of a matrix is the sum of all the squared elements of the matrix.
 
 - parameters:
    - arr: A 2d Matrix of shape (W,H).
 - returns: The norm value of a matrix
 - Author: Mohammad Sadil Khan
 */
func norm(_ arr: [[Double]]) -> Double {
    sum2DArray(multiply2DArray(arr, arr)).squareRoot()
}

/// Scales the image within [0,1].
/// - Parameter arr: A 2d array of shape (W,H)
/// - Returns: Returns  a scaled version of input arr whose elements are within [0,1]
func scaleImageBy255(_ arr: [[Double]]) -> [[Double]] {
    let scaledArray = arr.map { vector in
        vector.map { value in
            value / 255.0
        }
    }
    return scaledArray
}

/// Calculates mean of all the element values in a 2d array
/// - Parameter arr: A 2d array of shape (W,H)
/// - Returns:  Returns the mean value
func getMean2dArray(_ arr: [[Double]]) -> Double {
    let size = Double(arr.flatMap { vector in
        vector
    }.count)
    let mean = sum2DArray(arr) / size
    return mean
}


/// Subtracts mean from every element of a matrix.
/// - Parameter arr: A 2d array of shape (W,H)
/// - Returns: Returns the matrix - mean
func getMeanDiffMatrix(_ arr: [[Double]]) -> [[Double]] {
    let mean = getMean2dArray(arr)
    let meanDiffMat = arr.map { vector in
        vector.map { value in
            value - mean
        }
    }
    return meanDiffMat
}

/// Gets the maximum value of 2d matrix
/// - Parameter arr: A 2d array of shape (W,H)
/// - Returns: Returns the max value of input array
func getMaxArray(_ arr: [[Double]]) -> Double {
    let maxValue = arr.joined().max() ?? 0
    return maxValue
}

/// Rules for decimal round
enum PrecisionRoundingRule {
    case Zeros
    case Ones
    case Twos
    case Threes
    case Fours
    case Fives
    case Sixs
}

/// Decimal Rounding System
/// - Parameters:
///   - value: Double. The value to be rounded
///   - precision: Rule of rounding
/// - Returns: Rounded value
func roundDecimal(_ value: Double, _ precision: PrecisionRoundingRule = .Zeros) -> Double {

    switch precision {
    case .Zeros:
        return round(value)
    case .Ones:
        return round(value * 10) / 10.0
    case .Twos:
        return round(value * 100) / 100.0
    case .Threes:
        return round(value * 1000) / 1000.0
    case .Fours:
        return round(value * 10000) / 10000.0
    case .Fives:
        return round(value * 100000) / 100000.0
    case .Sixs:
        return round(value * 1000000) / 1000000.0
    }
}
