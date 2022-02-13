//
//  Jobs.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 13/02/2022.
//

import Foundation

struct Jobs {
    static var arrayOfJobs: [String] {
        if let jobsURL = Bundle.main.url(forResource: "job-list", withExtension: "txt") {
            if let jobs = try? String(contentsOf: jobsURL) {
                return jobs.components(separatedBy: "\n")
            }
        }
        return []
    }
}
