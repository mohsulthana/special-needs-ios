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
    
    struct FourthGradeDataModel: Encodable {
        let grade: String?
        let subjects: FourthGradeSubject?
    }
    
    struct FourthGradeSubject: Encodable {
        let reading_comprehesion: SubjectGoalsModel?
        let reading_fluency: SubjectGoalsModel?
        let writing: SubjectGoalsModel?
        let math_computation: SubjectGoalsModel?
        let math_word_problem: SubjectGoalsModel?
        let social_skills: SubjectGoalsModel?
        let behavior: SubjectGoalsModel?
    }
    
    struct NinthTenDataModel: Encodable {
        let grade: String?
        let subjects: NinthTenGradeSubject?
    }
    
    struct NinthTenGradeSubject: Encodable {
        let reading_comprehesion: SubjectGoalsModel?
        let reading: SubjectGoalsModel?
        let writing: SubjectGoalsModel?
        let social_skills: SubjectGoalsModel?
        let behavior: SubjectGoalsModel?
    }
    
    struct EvelenthTwelvethDataModel: Encodable {
        let grade: String?
        let subjects: EleventhTwelvethGradeSubject?
        let position: Int?
    }
    
    struct EleventhTwelvethGradeSubject: Encodable {
        let ELA: SubjectGoalsModel?
        let writing: SubjectGoalsModel?
        let math: SubjectGoalsModel?
    }
    
    struct SLPDataModel: Encodable {
        let grade: String?
        let subjects: SLPGradeSubject?
        let position: Int?
    }
    
    struct SLPGradeSubject: Encodable {
        let augmented_and_alterative_communication: SubjectGoalsModel?
        let phonological: SubjectGoalsModel?
        let expressive_language: SubjectGoalsModel?
        let receptive_language: SubjectGoalsModel?
        let articulation: SubjectGoalsModel?
        let fluency: SubjectGoalsModel?
    }
    
    struct OTDataModel: Encodable {
        let grade: String?
        let subjects: OTGradeSubject?
        let position: Int?
    }
    
    struct OTGradeSubject: Encodable {
        let cutting: SubjectGoalsModel?
        let blocks_and_puzzles: SubjectGoalsModel?
        let drawing: SubjectGoalsModel?
        let writing: SubjectGoalsModel?
        let grasp_and_release: SubjectGoalsModel?
        let self_care: SubjectGoalsModel?
    }
    
    struct IEPDataModel: Encodable {
        let grade: String?
        let subjects: IEPGradeSubject?
        let position: Int?
    }
    
    struct IEPGradeSubject: Encodable {
        let step_1: SubjectGoalsModel?
        let step_2: SubjectGoalsModel?
        let step_3: SubjectGoalsModel?
        let step_4: SubjectGoalsModel?
        let step_5: SubjectGoalsModel?
        let step_6: SubjectGoalsModel?
        let step_7: SubjectGoalsModel?
    }
}
