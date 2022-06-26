//
//  MergeVisitor.swift
//  QuranAndSunnah
//
//  Created by newone on 26/6/22.
//

import Foundation

protocol IVisitor {
    func mergeOverlapped(collection: inout [IHighlight])
}

class MergeVisitor: IVisitor {
    func mergeOverlapped(collection: inout [IHighlight]) {
        collection.sort { left, right in
            left.markedRange.lowerBound < right.markedRange.lowerBound
        }

        var newArray = [IHighlight]()

        if let first = collection.first {
            newArray.append(first)
        }

        collection.forEach { highlight in
            if newArray[newArray.count - 1].markedRange.upperBound >= highlight.markedRange.lowerBound - 1 {
                newArray[newArray.count - 1].markedRange =
                    newArray[newArray.count - 1].markedRange.lowerBound ... highlight.markedRange.upperBound
            } else {
                newArray.append(highlight)
            }
        }

        collection = newArray
    }
}
