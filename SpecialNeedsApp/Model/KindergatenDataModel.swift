//
//  KindergatenDataModel.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 21/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

struct FirestoreModel {
    struct KindergatenDataModel: Encodable {
        let grade: String?
        let subjects: KindergatenSubject?
    }

    struct KindergatenSubject: Encodable {
        let reading_comprehesion: SubjectGoalsModel?
        let reading_fluency: SubjectGoalsModel?
        let writing: SubjectGoalsModel?
        let math: SubjectGoalsModel?
        let social_skills: SubjectGoalsModel?
        let communication: SubjectGoalsModel?
        let behavior: SubjectGoalsModel?
    }
    
    struct FirstGradeDataModel: Encodable {
        let grade: String?
        let subjects: FirstGradeSubject?
    }
    
    struct FirstGradeSubject: Encodable {
        let reading_comprehesion: SubjectGoalsModel?
        let reading_fluency: SubjectGoalsModel?
        let writing: SubjectGoalsModel?
        let math_computation: SubjectGoalsModel?
        let math_word_problem: SubjectGoalsModel?
        let social_skills: SubjectGoalsModel?
        let communication: SubjectGoalsModel?
        let behavior: SubjectGoalsModel?
    }
}
