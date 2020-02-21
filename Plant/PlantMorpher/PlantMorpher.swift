//
//  PlantMorpher.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation

protocol PlantMorpher {
    func morph(_ plant1: Plant, _ plant2: Plant) -> Plant
}
