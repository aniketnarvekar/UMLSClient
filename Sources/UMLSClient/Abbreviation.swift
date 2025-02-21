//  Abbreviation.swift

/// UMLS supported Languages.
public enum UMLSLanguage: String, Sendable {
  /// Arabic
  case ara = "ARA"
  /// Basque
  case baq = "BAQ"
  /// Chinese
  case chi = "CHI"
  /// Czech
  case cze = "CZE"
  /// Danish
  case dan = "DAN"
  /// Dutch
  case dut = "DUT"
  /// English
  case eng = "ENG"
  /// Estonian
  case est = "EST"
  /// Finnish
  case fin = "FIN"
  /// French
  case fre = "FRE"
  /// German
  case ger = "GER"
  /// Greek
  case gre = "GRE"
  /// Hebrew
  case heb = "HEB"
  /// Hungarian
  case hun = "HUN"
  /// Italian
  case ita = "ITA"
  /// Japanese
  case jpn = "JPN"
  /// Korean
  case kor = "KOR"
  /// Latvian
  case lav = "LAV"
  /// Norwegian
  case nor = "NOR"
  /// Polish
  case pol = "POL"
  /// Portuguese
  case por = "POR"
  /// Russian
  case rus = "RUS"
  /// Croatian
  case scr = "SCR"
  /// Spanish
  case spa = "SPA"
  /// Swedish
  case swe = "SWE"
  /// Turkish
  case tur = "TUR"
  /// Ukrainian
  case ukr = "UKR"

}

extension UMLSLanguage: CaseIterable {}

extension UMLSLanguage: Decodable {}

/// The predefined term types in UMLS.
public enum UMLSTermType: String, Sendable {
  /// Attribute type abbreviation
  case aa = "AA"
  /// Abbreviation in any source vocabulary
  case ab = "AB"
  /// Acronym
  case acr = "ACR"
  /// Activities
  case ac = "AC"
  /// Adjective
  case ad = "AD"
  /// Short form of modifier
  case am = "AM"
  /// Attribute type synonym
  case `as` = "AS"
  /// Attribute type
  case at = "AT"
  /// Fully-specified drug brand name that can be prescribed
  case bd = "BD"
  /// Fully-specified drug brand name that can not be prescribed
  case bn = "BN"
  /// Branded Drug Delivery Device
  case bpck = "BPCK"
  /// Binding realm
  case br = "BR"
  /// ISO 3166-1 standard country code in alpha-2 (two-letter) format
  case ca2 = "CA2"
  /// ISO 3166-1 standard country code in alpha-3 (three-letter) format
  case ca3 = "CA3"
  /// Chemical code name
  case ccn = "CCN"
  /// FIPS 10-4 country code
  case ccs = "CCS"
  /// Trimmed ICPC component process
  case cc = "CC"
  /// Clinical drug name in abbreviated format
  case cda = "CDA"
  /// Clinical drug name in concatenated format (NDDF), Clinical drug name (NDFRT)
  case cdc = "CDC"
  /// Clinical drug name in delimited format
  case cdd = "CDD"
  /// Concept domain
  case cdo = "CDO"
  /// Clinical Drug
  case cd = "CD"
  /// Entry term for a Supplementary Concept
  case ce = "CE"
  /// Chemical structure name
  case chn = "CHN"
  /// Class
  case cl = "CL"
  /// Common name
  case cmn = "CMN"
  /// LOINC official component name
  case cn = "CN"
  /// Component name (these are hierarchical terms, as opposed to the LOINC component names which are analytes)
  case co = "CO"
  /// Concept property
  case cpr = "CPR"
  /// ICPC component process (in original form)
  case cp = "CP"
  /// Concept relationship
  case cr = "CR"
  /// Chemical Structure Name
  case csn = "CSN"
  /// Code system
  case csy = "CSY"
  /// Short component process in ICPC, i.e. include some abbreviations
  case cs = "CS"
  /// Common usage
  case cu = "CU"
  /// Content view
  case cv = "CV"
  /// Component, with abbreviations expanded.
  case cx = "CX"
  /// Diagnostic criteria for ICD10 code
  case dc10 = "DC10"
  /// Diagnostic criteria for ICD9 code
  case dc9 = "DC9"
  /// Descriptor entry version
  case dev = "DEV"
  /// Descriptor
  case de = "DE"
  /// Dose Form Group
  case dfg = "DFG"
  /// Dose Form
  case df = "DF"
  /// Disease name
  case di = "DI"
  /// Display Name
  case dn = "DN"
  /// Domain
  case `do` = "DO"
  /// Drug Product
  case dp = "DP"
  /// Descriptor sort version
  case dsv = "DSV"
  /// Short form of descriptor
  case ds = "DS"
  /// Definitional term, present in the Metathesaurus because of its connection to a Dorland's definition or to a definition created especially for the Metathesaurus
  case dt = "DT"
  /// Equivalent name
  case eq = "EQ"
  /// Short form of entry term
  case es = "ES"
  /// Entry Term Alias
  case etal = "ETAL"
  /// Entry term, consumer friendly description
  case etcf = "ETCF"
  /// Entry term, clinician description
  case etclin = "ETCLIN"
  /// Entry term
  case et = "ET"
  /// Expanded form of entry term
  case ex = "EX"
  /// Foreign brand name
  case fbd = "FBD"
  /// Finding name
  case fi = "FI"
  /// Full form of descriptor
  case fn = "FN"
  /// Foreign Synonym
  case fsy = "FSY"
  /// Global period
  case glp = "GLP"
  /// Generic drug name
  case gn = "GN"
  /// Goal
  case go = "GO"
  /// Generic Drug Delivery Device
  case gpck = "GPCK"
  /// Glossary term
  case gt = "GT"
  /// Hierarchical class
  case hc = "HC"
  /// Hierarchical descriptor
  case hd = "HD"
  /// High Level Group Term
  case hg = "HG"
  /// Short or alternate version of hierarchical term
  case hs = "HS"
  /// HL7 Table Name
  case htn = "HTN"
  /// Hierarchical term
  case ht = "HT"
  /// Expanded version of short hierarchical term
  case hx = "HX"
  /// Nursing indicator
  case id = "ID"
  /// Name for an ingredient
  case `in` = "IN"
  /// Obsolete Synonym
  case `is` = "IS"
  /// Index term
  case it = "IT"
  /// Intervention categories
  case ivc = "IVC"
  /// Intervention
  case iv = "IV"
  /// LOINC answer
  case la = "LA"
  /// Long common name
  case lc = "LC"
  /// LOINC group
  case lg = "LG"
  /// Lower Level Term
  case llt = "LLT"
  /// LOINC official fully specified name
  case ln = "LN"
  /// Obsolete official fully specified name
  case lo = "LO"
  /// LOINC parts display name
  case lpdn = "LPDN"
  /// LOINC parts name
  case lpn = "LPN"
  /// Expanded system/sample type (The expanded version was created for the Metathesaurus and includes the full name of some abbreviations.)
  case ls = "LS"
  /// Lexical variant
  case lv = "LV"
  /// CCS multi-level diagnosis categories
  case md = "MD"
  /// Main heading
  case mh = "MH"
  /// name for a multi-ingredient
  case min = "MIN"
  /// Preferred names of modifiers
  case mp = "MP"
  /// Multum names of branded and generic supplies or supplements
  case ms = "MS"
  /// MTH acronym
  case mthAcr = "MTH_ACR"
  /// MTH Component, with abbreviations expanded.
  case mthCn = "MTH_CN"
  /// Metathesaurus entry term
  case mthEt = "MTH_ET"
  /// MTH Full form of descriptor
  case mthFn = "MTH_FN"
  /// MTH High Level Group Term
  case mthHg = "MTH_HG"
  /// MTH Hierarchical term
  case mthHt = "MTH_HT"
  /// MTH Hierarchical term expanded
  case mthHx = "MTH_HX"
  /// Metathesaurus-supplied form of obsolete synonym
  case mthIs = "MTH_IS"
  /// MTH Lower Level Term
  case mthLlt = "MTH_LLT"
  /// MTH Official fully specified name with expanded abbreviations
  case mthLn = "MTH_LN"
  /// MTH Expanded LOINC obsolete fully specified name
  case mthLo = "MTH_LO"
  /// Metathesaurus-supplied form of obsolete active fully specified name
  case mthOaf = "MTH_OAF"
  /// Metathesaurus-supplied form of obsolete active preferred term
  case mthOap = "MTH_OAP"
  /// Metathesaurus-supplied form of obsolete active synonym
  case mthOas = "MTH_OAS"
  /// Metathesaurus obsolete entry term
  case mthOet = "MTH_OET"
  /// Metathesaurus-supplied form of obsolete fully specified name
  case mthOf = "MTH_OF"
  /// MTH Non-current Lower Level Term
  case mthOl = "MTH_OL"
  /// Metathesaurus obsolete preferred term, natural language form
  case mthOpn = "MTH_OPN"
  /// Metathesaurus obsolete preferred term
  case mthOp = "MTH_OP"
  /// MTH System-organ class
  case mthOs = "MTH_OS"
  /// Metathesaurus-supplied form of British preferred term
  case mthPtgb = "MTH_PTGB"
  /// Metathesaurus preferred term, natural language form
  case mthPtn = "MTH_PTN"
  /// Metathesaurus preferred term
  case mthPt = "MTH_PT"
  /// RxNorm Created BD
  case mthRxnBd = "MTH_RXN_BD"
  /// RxNorm Created CDC
  case mthRxnCdc = "MTH_RXN_CDC"
  /// RxNorm Created CD
  case mthRxnCd = "MTH_RXN_CD"
  /// RxNorm Created DP
  case mthRxnDp = "MTH_RXN_DP"
  /// MTH Sign or symptom of
  case mthSi = "MTH_SI"
  /// Metathesaurus version of Standardised MedDRA Query
  case mthSmq = "MTH_SMQ"
  /// Metathesaurus-supplied form of British synonym
  case mthSygb = "MTH_SYGB"
  /// MTH Designated synonym
  case mthSy = "MTH_SY"
  /// Multi-level procedure category
  case mv = "MV"
  /// Chemical Abstracts Service Type 1 name of a chemical
  case n1 = "N1"
  /// Name aliases
  case na = "NA"
  /// Name of Supplementary Concept
  case nm = "NM"
  /// HL7 non-preferred for language term
  case npt = "NPT"
  /// Non-preferred term
  case np = "NP"
  /// Short form of non-preferred term
  case ns = "NS"
  /// Expanded form of non-preferred term
  case nx = "NX"
  /// Obsolete active fully specified name
  case oaf = "OAF"
  /// Obsolete Modifier Abbreviation
  case oam = "OAM"
  /// Obsolete active preferred term
  case oap = "OAP"
  /// Obsolete active synonym
  case oas = "OAS"
  /// Obsolete abbreviation
  case oa = "OA"
  /// Nursing outcomes
  case oc = "OC"
  /// Obsolete entry term
  case oet = "OET"
  /// Obsolete fully specified name
  case of = "OF"
  /// Obsolete Long common name
  case olc = "OLC"
  /// Obsolete LOINC group name
  case olg = "OLG"
  /// Non-current Lower Level Term
  case ol = "OL"
  /// Obsolete modifiers in HCPCS
  case om = "OM"
  /// Obsolete non-preferred for language term
  case onp = "ONP"
  /// Obsolete official short name
  case oosn = "OOSN"
  /// Obsolete preferred term, natural language form
  case opn = "OPN"
  /// Obsolete preferred name
  case op = "OP"
  /// Orders
  case or = "OR"
  /// Official short name
  case osn = "OSN"
  /// System-organ class
  case os = "OS"
  /// Preferred entry term for Supplementary Concept
  case pce = "PCE"
  /// Preferred "trimmed term" in ICPC
  case pc = "PC"
  /// Preferred entry term
  case pep = "PEP"
  /// Phenotype entry term
  case phenoEt = "PHENO_ET"
  /// Phenotype
  case pheno = "PHENO"
  /// Name from a precise ingredient
  case pin = "PIN"
  /// Machine permutation
  case pm = "PM"
  /// Metathesaurus preferred name
  case pn = "PN"
  /// Place of service
  case pos = "POS"
  /// Qualifier for a problem
  case pq = "PQ"
  /// Name of a problem
  case pr = "PR"
  /// Protocol selection criteria
  case psc = "PSC"
  /// Prescribable Names
  case psn = "PSN"
  /// Short forms that needed full specification
  case ps = "PS"
  /// Preferred Allelic Variant
  case ptav = "PTAV"
  /// Preferred Clinical Synopsis
  case ptcs = "PTCS"
  /// British preferred term
  case ptgb = "PTGB"
  /// Preferred term, natural language form
  case ptn = "PTN"
  /// Designated preferred name
  case pt = "PT"
  /// Preferred qualifier term
  case pxq = "PXQ"
  /// Expanded preferred terms (pair with PS)
  case px = "PX"
  /// Qualifier abbreviation
  case qab = "QAB"
  /// Qualifier entry version
  case qev = "QEV"
  /// Qualifier sort version
  case qsv = "QSV"
  /// Root abbreviation
  case rab = "RAB"
  /// Root hierarchical term
  case rht = "RHT"
  /// Root preferred term
  case rpt = "RPT"
  /// Root synonym
  case rsy = "RSY"
  /// Extracted related names in SNOMED2
  case rs = "RS"
  /// Term that is related to, but often considered non-synonymous with, the preferred term
  case rt = "RT"
  /// Rxnorm Preferred Ingredient
  case rxnIn = "RXN_IN"
  /// Rxnorm Preferred
  case rxnPt = "RXN_PT"
  /// Semantic Branded Drug Component
  case sbdc = "SBDC"
  /// Semantic branded drug and form
  case sbdf = "SBDF"
  /// Semantic branded drug group
  case sbdg = "SBDG"
  /// Semantic branded drug
  case sbd = "SBD"
  /// Named subset of a source
  case sb = "SB"
  /// Scale
  case scale = "SCALE"
  /// Semantic Drug Component
  case scdc = "SCDC"
  /// Semantic clinical drug and form
  case scdf = "SCDF"
  /// Semantic clinical drug group
  case scdg = "SCDG"
  /// Semantic Clinical Drug
  case scd = "SCD"
  /// Scientific name
  case scn = "SCN"
  /// Special Category term
  case sc = "SC"
  /// CCS diagnosis categories
  case sd = "SD"
  /// Name of a sign or symptom of a problem
  case si = "SI"
  /// Standardised MedDRA Query
  case smq = "SMQ"
  /// CCS procedure categories
  case sp = "SP"
  /// Source short name, used in the UMLS Knowledge Source Server
  case ssn = "SSN"
  /// Synonymous "short" forms
  case ss = "SS"
  /// Step
  case st = "ST"
  /// Active Substance
  case su = "SU"
  /// Mixed-case component synonym with expanded abbreviations
  case sx = "SX"
  /// British synonym
  case sygb = "SYGB"
  /// Designated alias
  case syn = "SYN"
  /// Designated synonym
  case sy = "SY"
  /// Task
  case ta = "TA"
  /// Term class
  case tc = "TC"
  /// Name of the target of an intervention
  case tg = "TG"
  /// Tall Man synonym
  case tmsy = "TMSY"
  /// Topical qualifier
  case tq = "TQ"
  /// CCPSS synthesized problems for TC termgroup
  case tx = "TX"
  /// Unique common name
  case ucn = "UCN"
  /// Unique equivalent name
  case ue = "UE"
  /// Unique scientific name
  case usn = "USN"
  /// Unique synonym
  case usy = "USY"
  /// Versioned abbreviation
  case vab = "VAB"
  /// Versioned preferred term
  case vpt = "VPT"
  /// Versioned synonym
  case vsy = "VSY"
  /// Value Set
  case vs = "VS"
  /// Expanded descriptor in AOD
  case xd = "XD"
  /// Cross mapping set
  case xm = "XM"
  /// Alternate name for a qualifier
  case xq = "XQ"
}

extension UMLSTermType: CaseIterable {}

extension UMLSTermType: Decodable {}

/// UMLS Additional relation lable.
public enum UMLSAdditionalRelationLabel: String {
  /// Induces
  case induces = "induces"
  /// abnormal cell affected by chemical or drug
  case abnormalCellAffectedByChemicalOrDrug = "abnormal_cell_affected_by_chemical_or_drug"
  /// abnormality associated with allele
  case abnormalityAssociatedWithAllele = "abnormality_associated_with_allele"
  /// Absorbability of
  case absorbabilityOf = "absorbability_of"
  /// Access device used by
  case accessDeviceUsedBy = "access_device_used_by"
  /// Access instrument of
  case accessInstrumentOf = "access_instrument_of"
  /// Access of
  case accessOf = "access_of"
  /// Acted on by process
  case actedOnByProcess = "acted_on_by_process"
  /// Active ingredient of
  case activeIngredientOf = "active_ingredient_of"
  /// Active metabolites of
  case activeMetabolitesOf = "active_metabolites_of"
  /// Active Moiety of
  case activeMoietyOf = "active_moiety_of"
  /// activity of allele
  case activityOfAllele = "activity_of_allele"
  /// Actual outcome of
  case actualOutcomeOf = "actual_outcome_of"
  /// Add on code for (Report with)
  case addOnCodeFor = "add_on_code_for"
  /// Adheres to
  case adheresTo = "adheres_to"
  /// Adjacent to
  case adjacentTo = "adjacent_to"
  /// Adjectival form of
  case adjectivalFormOf = "adjectival_form_of"
  /// Adjustment of
  case adjustmentOf = "adjustment_of"
  /// Afferent to
  case afferentTo = "afferent_to"
  /// After
  case after = "after"
  /// Alias_of
  case aliasOf = "alias_of"
  /// allele absent from wild-type chromosomal location
  case alleleAbsentFromWildTypeChromosomalLocation =
    "allele_absent_from_wild-type_chromosomal_location"
  /// allele has abnormality
  case alleleHasAbnormality = "allele_has_abnormality"
  /// allele has activity
  case alleleHasActivity = "allele_has_activity"
  /// allele in chromosomal location
  case alleleInChromosomalLocation = "allele_in_chromosomal_location"
  /// allele plays altered role in process
  case allelePlaysAlteredRoleInProcess = "allele_plays_altered_role_in_process"
  /// allele plays role in metabolism of chemical or drug
  case allelePlaysRoleInMetabolismOfChemicalOrDrug =
    "allele_plays_role_in_metabolism_of_chemical_or_drug"
  /// Allelic Variant of
  case allelicVariantOf = "allelic_variant_of"
  /// Alternative of
  case alternativeOf = "alternative_of"
  /// Analyzed by
  case analyzedBy = "analyzed_by"
  /// Analyzes
  case analyzes = "analyzes"
  /// anatomic structure has location
  case anatomicStructureHasLocation = "anatomic_structure_has_location"
  /// anatomic structure is physical part of
  case anatomicStructureIsPhysicalPartOf = "anatomic_structure_is_physical_part_of"
  /// anatomical entity observed in
  case anatomicalEntityObservedIn = "anatomical_entity_observed_in"
  /// anatomy originated from biological process
  case anatomyOriginatedFromBiologicalProcess = "anatomy_originated_from_biological_process"
  /// Answer to is sterile
  case answerToIsSterile = "answer_to_is_sterile"
  /// answer to
  case answerTo = "answer_to"
  /// anterior to
  case anteriorTo = "anterior_to"
  /// anteroinferior to
  case anteroinferiorTo = "anteroinferior_to"
  /// anterolateral to
  case anterolateralTo = "anterolateral_to"
  /// anteromedial to
  case anteromedialTo = "anteromedial_to"
  /// anterosuperior to
  case anterosuperiorTo = "anterosuperior_to"
  /// Approach of excluded
  case approachOfExcluded = "approach_of_excluded"
  /// Approach of possibly included
  case approachOfPossiblyIncluded = "approach_of_possibly_included"
  /// Approach of
  case approachOf = "approach_of"
  /// Archetype of
  case archetypeOf = "archetype_of"
  /// Arterial supply of
  case arterialSupplyOf = "arterial_supply_of"
  /// Articulates with
  case articulatesWith = "articulates_with"
  /// Associated condition of
  case associatedConditionOf = "associated_condition_of"
  /// Associated disease
  case associatedDisease = "associated_disease"
  /// Associated etiologic finding of
  case associatedEtiologicFindingOf = "associated_etiologic_finding_of"
  /// Associated finding of excluded
  case associatedFindingOfExcluded = "associated_finding_of_excluded"
  /// Associated finding of possibly included
  case associatedFindingOfPossiblyIncluded = "associated_finding_of_possibly_included"
  /// Associated finding of
  case associatedFindingOf = "associated_finding_of"
  /// Associated function of
  case associatedFunctionOf = "associated_function_of"
  /// Associated genetic condition
  case associatedGeneticCondition = "associated_genetic_condition"
  /// Associated morphology of
  case associatedMorphologyOf = "associated_morphology_of"
  /// Associated observation of
  case associatedObservationOf = "associated_observation_of"
  /// Associated procedure of excluded
  case associatedProcedureOfExcluded = "associated_procedure_of_excluded"
  /// Associated procedure of possibly included
  case associatedProcedureOfPossiblyIncluded = "associated_procedure_of_possibly_included"
  /// Associated procedure of
  case associatedProcedureOf = "associated_procedure_of"
  /// associated with malfunction of gene product
  case associatedWithMalfunctionOfGeneProduct = "associated_with_malfunction_of_gene_product"
  /// Associated with
  case associatedWith = "associated_with"
  /// Attaches to
  case attachesTo = "attaches_to"
  /// Basic dose form of
  case basicDoseFormOf = "basic_dose_form_of"
  /// Basis of strength substance of
  case basisOfStrengthSubstanceOf = "basis_of_strength_substance_of"
  /// Before
  case before = "before"
  /// biological process has associated location
  case biologicalProcessHasAssociatedLocation = "biological_process_has_associated_location"
  /// biological process has initiator chemical or drug
  case biologicalProcessHasInitiatorChemicalOrDrug =
    "biological_process_has_initiator_chemical_or_drug"
  /// biological process has initiator process
  case biologicalProcessHasInitiatorProcess = "biological_process_has_initiator_process"
  /// biological process has result anatomy
  case biologicalProcessHasResultAnatomy = "biological_process_has_result_anatomy"
  /// biological process has result biological process
  case biologicalProcessHasResultBiologicalProcess =
    "biological_process_has_result_biological_process"
  /// biological process has result chemical or drug
  case biologicalProcessHasResultChemicalOrDrug = "biological_process_has_result_chemical_or_drug"
  /// biological process involves chemical or drug
  case biologicalProcessInvolvesChemicalOrDrug = "biological_process_involves_chemical_or_drug"
  /// biological process involves gene product
  case biologicalProcessInvolvesGeneProduct = "biological_process_involves_gene_product"
  /// biological process is part of process
  case biologicalProcessIsPartOfProcess = "biological_process_is_part_of_process"
  /// biological process results from biological process
  case biologicalProcessResultsFromBiologicalProcess =
    "biological_process_results_from_biological_process"
  /// biomarker type includes gene product
  case biomarkerTypeIncludesGeneProduct = "biomarker_type_includes_gene_product"
  /// biomarker type includes gene
  case biomarkerTypeIncludesGene = "biomarker_type_includes_gene"
  /// Bounded by
  case boundedBy = "bounded_by"
  /// Bounds
  case bounds = "bounds"
  /// Branch of
  case branchOf = "branch_of"
  /// British form of
  case britishFormOf = "british_form_of"
  /// Causative agent of
  case causativeAgentOf = "causative_agent_of"
  /// Cause of
  case causeOf = "cause_of"
  /// cell type is associated with eo disease
  case cellTypeIsAssociatedWithEoDisease = "cell_type_is_associated_with_eo_disease"
  /// cell type or tissue affected by chemical or drug
  case cellTypeOrTissueAffectedByChemicalOrDrug = "cell_type_or_tissue_affected_by_chemical_or_drug"
  /// Challenge of
  case challengeOf = "challenge_of"
  /// Characterized by
  case characterizedBy = "characterized_by"
  /// Characterizes
  case characterizes = "characterizes"
  /// chemical or drug affects abnormal cell
  case chemicalOrDrugAffectsAbnormalCell = "chemical_or_drug_affects_abnormal_cell"
  /// chemical or drug affects cell type or tissue
  case chemicalOrDrugAffectsCellTypeOrTissue = "chemical_or_drug_affects_cell_type_or_tissue"
  /// chemical or drug affects gene product
  case chemicalOrDrugAffectsGeneProduct = "chemical_or_drug_affects_gene_product"
  /// chemical or drug has mechanism of action
  case chemicalOrDrugHasMechanismOfAction = "chemical_or_drug_has_mechanism_of_action"
  /// chemical or drug has physiologic effect
  case chemicalOrDrugHasPhysiologicEffect = "chemical_or_drug_has_physiologic_effect"
  /// chemical or drug initiates biological process
  case chemicalOrDrugInitiatesBiologicalProcess = "chemical_or_drug_initiates_biological_process"
  /// chemical or drug is metabolized by enzyme
  case chemicalOrDrugIsMetabolizedByEnzyme = "chemical_or_drug_is_metabolized_by_enzyme"
  /// chemical or drug is product of biological process
  case chemicalOrDrugIsProductOfBiologicalProcess =
    "chemical_or_drug_is_product_of_biological_process"
  /// chemical or drug metabolism is associated with allele
  case chemicalOrDrugMetabolismIsAssociatedWithAllele =
    "chemical_or_drug_metabolism_is_associated_with_allele"
  /// chemical or drug plays role in biological process
  case chemicalOrDrugPlaysRoleInBiologicalProcess =
    "chemical_or_drug_plays_role_in_biological_process"
  /// chemotherapy regimen has component
  case chemotherapyRegimenHasComponent = "chemotherapy_regimen_has_component"
  /// chromosomal location of allele
  case chromosomalLocationOfAllele = "chromosomal_location_of_allele"
  /// chromosomal location of wild-type gene
  case chromosomalLocationOfWildTypeGene = "chromosomal_location_of_wild-type_gene"
  /// chromosome involved in cytogenetic abnormality
  case chromosomeInvolvedInCytogeneticAbnormality = "chromosome_involved_in_cytogenetic_abnormality"
  /// chromosome mapped to disease
  case chromosomeMappedToDisease = "chromosome_mapped_to_disease"
  /// Class code classified by
  case classCodeClassifiedBy = "class_code_classified_by"
  /// Class of
  case classOf = "class_of"
  /// Classified as
  case classifiedAs = "classified_as"
  /// Classifies class code
  case classifiesClassCode = "classifies_class_code"
  /// Classifies
  case classifies = "classifies"
  /// Clinical course of
  case clinicalCourseOf = "clinical_course_of"
  /// Clinically associated with
  case clinicallyAssociatedWith = "clinically_associated_with"
  /// Clinically similar
  case clinicallySimilar = "clinically_similar"
  /// Clinician form of
  case clinicianFormOf = "clinician_form_of"
  /// Co-ocurrs with
  case coOccursWith = "co-occurs_with"
  /// Coating material of
  case coatingMaterialOf = "coating_material_of"
  /// common name of
  case commonNameOf = "common_name_of"
  /// completely excised anatomy has procedure
  case completelyExcisedAnatomyHasProcedure = "completely_excised_anatomy_has_procedure"
  /// Completely excised anatomy may have procedure
  case completelyExcisedAnatomyMayHaveProcedure = "completely_excised_anatomy_may_have_procedure"
  /// complex has physical part
  case complexHasPhysicalPart = "complex_has_physical_part"
  /// Component of excluded
  case componentOfExcluded = "component_of_excluded"
  /// Component of possibly included
  case componentOfPossiblyIncluded = "component_of_possibly_included"
  /// Component of
  case componentOf = "component_of"
  /// Compositional material of
  case compositionalMaterialOf = "compositional_material_of"
  /// Concentration strength denominator unit of
  case concentrationStrengthDenominatorUnitOf = "concentration_strength_denominator_unit_of"
  /// Concentration strength denominator value of
  case concentrationStrengthDenominatorValueOf = "concentration_strength_denominator_value_of"
  /// Concentration strength numerator unit of
  case concentrationStrengthNumeratorUnitOf = "concentration_strength_numerator_unit_of"
  /// Concentration strength numerator value of
  case concentrationStrengthNumeratorValueOf = "concentration_strength_numerator_value_of"
  /// concept in subset
  case conceptInSubset = "concept_in_subset"
  /// Conceptual part of
  case conceptualPartOf = "conceptual_part_of"
  /// connected to
  case connectedTo = "connected_to"
  /// connection type of
  case connectionTypeOf = "connection_type_of"
  /// Consider from
  case considerFrom = "consider_from"
  /// Consider
  case consider = "consider"
  /// Consists of
  case consistsOf = "consists_of"
  /// Constitutes
  case constitutes = "constitutes"
  /// Constitutional part of
  case constitutionalPartOf = "constitutional_part_of"
  /// Consumer friendly form of
  case consumerFriendlyFormOf = "consumer_friendly_form_of"
  /// Contained in
  case containedIn = "contained_in"
  /// Contains
  case contains = "contains"
  /// Context binding of
  case contextBindingOf = "context_binding_of"
  /// Continuation branch of
  case continuationBranchOf = "continuation_branch_of"
  /// continuous distally with
  case continuousDistallyWith = "continuous_distally_with"
  /// continuous proximally with
  case continuousProximallyWith = "continuous_proximally_with"
  /// Continuous with
  case continuousWith = "continuous_with"
  /// Contraindicated class of
  case contraindicatedClassOf = "contraindicated_class_of"
  /// Contraindicated mechanism of action of
  case contraindicatedMechanismOfActionOf = "contraindicated_mechanism_of_action_of"
  /// Contraindicated physiologic effect of
  case contraindicatedPhysiologicEffectOf = "contraindicated_physiologic_effect_of"
  /// Contraindicated with disease
  case contraindicatedWithDisease = "contraindicated_with_disease"
  /// corresponds to
  case correspondsTo = "corresponds_to"
  /// Count of active ingredient of
  case countOfActiveIngredientOf = "count_of_active_ingredient_of"
  /// Count of base of active ingredient of
  case countOfBaseOfActiveIngredientOf = "count_of_base_of_active_ingredient_of"
  /// count_of
  case countOf = "count_of"
  /// Course of
  case courseOf = "course_of"
  /// ctcae_5 parent of
  case ctcae5ParentOf = "ctcae_5_parent_of"
  /// cytogenetic abnormality involves chromosome
  case cytogeneticAbnormalityInvolvesChromosome = "cytogenetic_abnormality_involves_chromosome"
  /// data element of
  case dataElementOf = "data_element_of"
  /// dxx
  case ddx = "ddx"
  /// Default inpatient classification of
  case defaultInpatientClassificationOf = "default_inpatient_classification_of"
  /// Default mapped from
  case defaultMappedFrom = "default_mapped_from"
  /// Default mapped to
  case defaultMappedTo = "default_mapped_to"
  /// Default outpatient classification of
  case defaultOutpatientClassificationOf = "default_outpatient_classification_of"
  /// Defining characteristic of
  case definingCharacteristicOf = "defining_characteristic_of"
  /// Definitional manifestation of
  case definitionalManifestationOf = "definitional_manifestation_of"
  /// Degree of
  case degreeOf = "degree_of"
  /// Dependent of
  case dependentOf = "dependent_of"
  /// derives from
  case derivesFrom = "derives_from"
  /// derives
  case derives = "derives"
  /// development type of
  case developmentTypeOf = "development_type_of"
  /// developmental stage of
  case developmentalStageOf = "developmental_stage_of"
  /// Develops from
  case developsFrom = "develops_from"
  /// develops into
  case developsInto = "develops_into"
  /// Device characteristic of
  case deviceCharacteristicOf = "device_characteristic_of"
  /// Device intended site of
  case deviceIntendedSiteOf = "device_intended_site_of"
  /// Device used by
  case deviceUsedBy = "device_used_by"
  /// Diagnosed by
  case diagnosedBy = "diagnosed_by"
  /// Diagnoses
  case diagnoses = "diagnoses"
  /// DSM-5 diagnostic criteria for ICD code
  case diagnosticCriteriaOf = "diagnostic_criteria_of"
  /// direct cell shape of
  case directCellShapeOf = "direct_cell_shape_of"
  /// Direct device of
  case directDeviceOf = "direct_device_of"
  /// direct left of
  case directLeftOf = "direct_left_of"
  /// Direct morphology of
  case directMorphologyOf = "direct_morphology_of"
  /// Direct procedure site of
  case directProcedureSiteOf = "direct_procedure_site_of"
  /// direct right of
  case directRightOf = "direct_right_of"
  /// Direct site of
  case directSiteOf = "direct_site_of"
  /// Direct substance of
  case directSubstanceOf = "direct_substance_of"
  /// disease excludes abnormal cell
  case diseaseExcludesAbnormalCell = "disease_excludes_abnormal_cell"
  /// disease excludes cytogenetic abnormality
  case diseaseExcludesCytogeneticAbnormality = "disease_excludes_cytogenetic_abnormality"
  /// disease excludes finding
  case diseaseExcludesFinding = "disease_excludes_finding"
  /// disease excludes metastatic anatomic site
  case diseaseExcludesMetastaticAnatomicSite = "disease_excludes_metastatic_anatomic_site"
  /// disease excludes molecular abnormality
  case diseaseExcludesMolecularAbnormality = "disease_excludes_molecular_abnormality"
  /// disease excludes normal cell origin
  case diseaseExcludesNormalCellOrigin = "disease_excludes_normal_cell_origin"
  /// disease excludes normal tissue origin
  case diseaseExcludesNormalTissueOrigin = "disease_excludes_normal_tissue_origin"
  /// disease excludes primary anatomic site
  case diseaseExcludesPrimaryAnatomicSite = "disease_excludes_primary_anatomic_site"
  /// disease has abnormal cell
  case diseaseHasAbnormalCell = "disease_has_abnormal_cell"
  /// Disease Has Accepted Treatment With Regimen
  case diseaseHasAcceptedTreatmentWithRegimen = "disease_has_accepted_treatment_with_regimen"
  /// disease has associated anatomic site
  case diseaseHasAssociatedAnatomicSite = "disease_has_associated_anatomic_site"
  /// disease has associated disease
  case diseaseHasAssociatedDisease = "disease_has_associated_disease"
  /// disease has associated gene
  case diseaseHasAssociatedGene = "disease_has_associated_gene"
  /// disease has cytogenetic abnormality
  case diseaseHasCytogeneticAbnormality = "disease_has_cytogenetic_abnormality"
  /// disease has finding
  case diseaseHasFinding = "disease_has_finding"
  /// disease has metastatic anatomic site
  case diseaseHasMetastaticAnatomicSite = "disease_has_metastatic_anatomic_site"
  /// disease has molecular abnormality
  case diseaseHasMolecularAbnormality = "disease_has_molecular_abnormality"
  /// disease has normal cell origin
  case diseaseHasNormalCellOrigin = "disease_has_normal_cell_origin"
  /// disease has normal tissue origin
  case diseaseHasNormalTissueOrigin = "disease_has_normal_tissue_origin"
  /// disease has primary anatomic site
  case diseaseHasPrimaryAnatomicSite = "disease_has_primary_anatomic_site"
  /// disease is grade
  case diseaseIsGrade = "disease_is_grade"
  /// disease is marked by gene
  case diseaseIsMarkedByGene = "disease_is_marked_by_gene"
  /// disease is stage
  case diseaseIsStage = "disease_is_stage"
  /// disease mapped to chromosome
  case diseaseMappedToChromosome = "disease_mapped_to_chromosome"
  /// Disease mapped to gene
  case diseaseMappedToGene = "disease_mapped_to_gene"
  /// disease may have abnormal cell
  case diseaseMayHaveAbnormalCell = "disease_may_have_abnormal_cell"
  /// disease may have associated disease
  case diseaseMayHaveAssociatedDisease = "disease_may_have_associated_disease"
  /// disease may have cytogenetic abnormality
  case diseaseMayHaveCytogeneticAbnormality = "disease_may_have_cytogenetic_abnormality"
  /// disease may have finding
  case diseaseMayHaveFinding = "disease_may_have_finding"
  /// disease may have molecular abnormality
  case diseaseMayHaveMolecularAbnormality = "disease_may_have_molecular_abnormality"
  /// disease may have normal cell origin
  case diseaseMayHaveNormalCellOrigin = "disease_may_have_normal_cell_origin"
  /// disease may have normal tissue origin
  case diseaseMayHaveNormalTissueOrigin = "disease_may_have_normal_tissue_origin"
  /// Disposition of
  case dispositionOf = "disposition_of"
  /// distal to
  case distalTo = "distal_to"
  /// Divisor of
  case divisorOf = "divisor_of"
  /// Do not code with (excludes)
  case doNotCodeWith = "do_not_code_with"
  /// Dose form administration method of
  case doseFormAdministrationMethodOf = "dose_form_administration_method_of"
  /// Dose form intended site of
  case doseFormIntendedSiteOf = "dose_form_intended_site_of"
  /// Dose form of
  case doseFormOf = "dose_form_of"
  /// Dose form release characteristic of
  case doseFormReleaseCharacteristicOf = "dose_form_release_characteristic_of"
  /// Dose form transformation of
  case doseFormTransformationOf = "dose_form_transformation_of"
  /// Dose form group of
  case doseformgroupOf = "doseformgroup_of"
  /// drains into
  case drainsInto = "drains_into"
  /// Due to
  case dueTo = "due_to"
  /// During
  case during = "during"
  /// Effect may be inhibited by
  case effectMayBeInhibitedBy = "effect_may_be_inhibited_by"
  /// Efferent to
  case efferentTo = "efferent_to"
  /// Endogenous Product Related To
  case endogenousProductRelatedTo = "endogenous_product_related_to"
  /// Ends during
  case endsDuring = "ends_during"
  /// Energy used by
  case energyUsedBy = "energy_used_by"
  /// Entire anatomy structure of
  case entireAnatomyStructureOf = "entire_anatomy_structure_of"
  /// Entry term of
  case entryTermOf = "entry_term_of"
  /// Entry version of
  case entryVersionOf = "entry_version_of"
  /// enzyme metabolizes chemical or drug
  case enzymeMetabolizesChemicalOrDrug = "enzyme_metabolizes_chemical_or_drug"
  /// eo anatomy is associated with eo disease
  case eoAnatomyIsAssociatedWithEoDisease = "eo_anatomy_is_associated_with_eo_disease"
  /// eo disease has associated cell type
  case eoDiseaseHasAssociatedCellType = "eo_disease_has_associated_cell_type"
  /// eo disease has associated eo anatomy
  case eoDiseaseHasAssociatedEoAnatomy = "eo_disease_has_associated_eo_anatomy"
  /// eo disease has property or attribute
  case eoDiseaseHasPropertyOrAttribute = "eo_disease_has_property_or_attribute"
  /// eo disease maps to human disease
  case eoDiseaseMapsToHumanDisease = "eo_disease_maps_to_human_disease"
  /// Episodicity of
  case episodicityOf = "episodicity_of"
  /// Evaluation of
  case evaluationOf = "evaluation_of"
  /// excised anatomy has procedure
  case excisedAnatomyHasProcedure = "excised_anatomy_has_procedure"
  /// excised anatomy may have procedure
  case excisedAnatomyMayHaveProcedure = "excised_anatomy_may_have_procedure"
  /// Exhibited by
  case exhibitedBy = "exhibited_by"
  /// Exhibits
  case exhibits = "exhibits"
  /// Expanded form of
  case expandedFormOf = "expanded_form_of"
  /// Expected outcome of
  case expectedOutcomeOf = "expected_outcome_of"
  /// Extended to by process
  case extendedToByProcess = "extended_to_by_process"
  /// Extent of
  case extentOf = "extent_of"
  /// external to
  case externalTo = "external_to"
  /// Filling of
  case fillingOf = "filling_of"
  /// Finding context of
  case findingContextOf = "finding_context_of"
  /// Finding informer of
  case findingInformerOf = "finding_informer_of"
  /// Finding method of
  case findingMethodOf = "finding_method_of"
  /// Finding site of
  case findingSiteOf = "finding_site_of"
  /// Focus of
  case focusOf = "focus_of"
  /// Form of
  case formOf = "form_of"
  /// formed by
  case formedBy = "formed_by"
  /// forms
  case forms = "forms"
  /// full grown phenotype of
  case fullGrownPhenotypeOf = "full_grown_phenotype_of"
  /// fuses with
  case fusesWith = "fuses_with"
  /// fusion of
  case fusionOf = "fusion_of"
  /// gene associated with disease
  case geneAssociatedWithDisease = "gene_associated_with_disease"
  /// gene encodes gene product
  case geneEncodesGeneProduct = "gene_encodes_gene_product"
  /// gene found in organism
  case geneFoundInOrganism = "gene_found_in_organism"
  /// gene has abnormality
  case geneHasAbnormality = "gene_has_abnormality"
  /// gene has physical location
  case geneHasPhysicalLocation = "gene_has_physical_location"
  /// gene in chromosomal location
  case geneInChromosomalLocation = "gene_in_chromosomal_location"
  /// gene involved in molecular abnormality
  case geneInvolvedInMolecularAbnormality = "gene_involved_in_molecular_abnormality"
  /// gene involved in pathogenesis of disease
  case geneInvolvedInPathogenesisOfDisease = "gene_involved_in_pathogenesis_of_disease"
  /// gene is biomarker of
  case geneIsBiomarkerOf = "gene_is_biomarker_of"
  /// gene is biomarker type
  case geneIsBiomarkerType = "gene_is_biomarker_type"
  /// gene is element in pathway
  case geneIsElementInPathway = "gene_is_element_in_pathway"
  /// gene mapped to disease
  case geneMappedToDisease = "gene_mapped_to_disease"
  /// gene mutant encodes gene product sequence variation
  case geneMutantEncodesGeneProductSequenceVariation =
    "gene_mutant_encodes_gene_product_sequence_variation"
  /// gene plays role in process
  case genePlaysRoleInProcess = "gene_plays_role_in_process"
  /// gene product affected by chemical or drug
  case geneProductAffectedByChemicalOrDrug = "gene_product_affected_by_chemical_or_drug"
  /// gene product encoded by gene
  case geneProductEncodedByGene = "gene_product_encoded_by_gene"
  /// gene product expressed in tissue
  case geneProductExpressedInTissue = "gene_product_expressed_in_tissue"
  /// gene product has abnormality
  case geneProductHasAbnormality = "gene_product_has_abnormality"
  /// gene product has associated anatomy
  case geneProductHasAssociatedAnatomy = "gene_product_has_associated_anatomy"
  /// gene product has biochemical function
  case geneProductHasBiochemicalFunction = "gene_product_has_biochemical_function"
  /// gene product has chemical classification
  case geneProductHasChemicalClassification = "gene_product_has_chemical_classification"
  /// gene product has gene product variant
  case geneProductHasGeneProductVariant = "gene_product_has_gene_product_variant"
  /// gene product has organism source
  case geneProductHasOrganismSource = "gene_product_has_organism_source"
  /// gene product has structural domain or motif
  case geneProductHasStructuralDomainOrMotif = "gene_product_has_structural_domain_or_motif"
  /// gene product is biomarker of
  case geneProductIsBiomarkerOf = "gene_product_is_biomarker_of"
  /// gene product is biomarker type
  case geneProductIsBiomarkerType = "gene_product_is_biomarker_type"
  /// gene product is element in pathway
  case geneProductIsElementInPathway = "gene_product_is_element_in_pathway"
  /// gene product is physical part of
  case geneProductIsPhysicalPartOf = "gene_product_is_physical_part_of"
  /// gene product malfunction associated with disease
  case geneProductMalfunctionAssociatedWithDisease =
    "gene_product_malfunction_associated_with_disease"
  /// gene product plays role in biological process
  case geneProductPlaysRoleInBiologicalProcess = "gene_product_plays_role_in_biological_process"
  /// gene product sequence variation encoded by gene mutant
  case geneProductSequenceVariationEncodedByGeneMutant =
    "gene_product_sequence_variation_encoded_by_gene_mutant"
  /// gene product variant of gene product
  case geneProductVariantOfGeneProduct = "gene_product_variant_of_gene_product"
  /// genetic biomarker related to
  case geneticBiomarkerRelatedTo = "genetic_biomarker_related_to"
  /// Germ origin of
  case germOriginOf = "germ_origin_of"
  /// grade of
  case gradeOf = "grade_of"
  /// Happens during
  case happensDuring = "happens_during"
  /// Has absorbability
  case hasAbsorbability = "has_absorbability"
  /// Has access instrument
  case hasAccessInstrument = "has_access_instrument"
  /// Has access
  case hasAccess = "has_access"
  /// Has action guidance
  case hasActionGuidance = "has_action_guidance"
  /// Has active ingredient
  case hasActiveIngredient = "has_active_ingredient"
  /// Has active metabolites
  case hasActiveMetabolites = "has_active_metabolites"
  /// Has Active Moiety
  case hasActiveMoiety = "has_active_moiety"
  /// Has actual outcome
  case hasActualOutcome = "has_actual_outcome"
  /// Has add on code (Report with)
  case hasAddOnCode = "has_add_on_code"
  /// Has adherent
  case hasAdherent = "has_adherent"
  /// Has adjustment
  case hasAdjustment = "has_adjustment"
  /// Has aggregation view
  case hasAggregationView = "has_aggregation_view"
  /// Has alias
  case hasAlias = "has_alias"
  /// Has allelic variant
  case hasAllelicVariant = "has_allelic_variant"
  /// Has alternative
  case hasAlternative = "has_alternative"
  /// has answer
  case hasAnswer = "has_answer"
  /// Has approach guidance
  case hasApproachGuidance = "has_approach_guidance"
  /// Has approach
  case hasApproach = "has_approach"
  /// Has archetype
  case hasArchetype = "has_archetype"
  /// Has arterial supply
  case hasArterialSupply = "has_arterial_supply"
  /// has_associated_condition
  case hasAssociatedCondition = "has_associated_condition"
  /// Has associated etiologic finding
  case hasAssociatedEtiologicFinding = "has_associated_etiologic_finding"
  /// Has associated finding
  case hasAssociatedFinding = "has_associated_finding"
  /// Has associated function
  case hasAssociatedFunction = "has_associated_function"
  /// Has associated morphology
  case hasAssociatedMorphology = "has_associated_morphology"
  /// Has associated observation
  case hasAssociatedObservation = "has_associated_observation"
  /// Has associated procedure
  case hasAssociatedProcedure = "has_associated_procedure"
  /// Has at risk population
  case hasAtRiskPopulation = "has_at_risk_population"
  /// Has basic dose form
  case hasBasicDoseForm = "has_basic_dose_form"
  /// Has basis of strength substance
  case hasBasisOfStrengthSubstance = "has_basis_of_strength_substance"
  /// Has branch
  case hasBranch = "has_branch"
  /// Has British form
  case hasBritishForm = "has_british_form"
  /// Has causative agent
  case hasCausativeAgent = "has_causative_agent"
  /// Has challenge
  case hasChallenge = "has_challenge"
  /// Has class
  case hasClass = "has_class"
  /// Has clinical course
  case hasClinicalCourse = "has_clinical_course"
  /// Has clinician form
  case hasClinicianForm = "has_clinician_form"
  /// Has coating material
  case hasCoatingMaterial = "has_coating_material"
  /// Has common name
  case hasCommonName = "has_common_name"
  /// Has communication with wound
  case hasCommunicationWithWound = "has_communication_with_wound"
  /// Has component
  case hasComponent = "has_component"
  /// Has compositional material
  case hasCompositionalMaterial = "has_compositional_material"
  /// Has concentration strength denominator unit
  case hasConcentrationStrengthDenominatorUnit = "has_concentration_strength_denominator_unit"
  /// Has concentration strength denominator value
  case hasConcentrationStrengthDenominatorValue = "has_concentration_strength_denominator_value"
  /// Has concentration strength numerator unit
  case hasConcentrationStrengthNumeratorUnit = "has_concentration_strength_numerator_unit"
  /// Has concentration strength numerator value
  case hasConcentrationStrengthNumeratorValue = "has_concentration_strength_numerator_value"
  /// Has conceptual part
  case hasConceptualPart = "has_conceptual_part"
  /// has connection type
  case hasConnectionType = "has_connection_type"
  /// Has constitutional part
  case hasConstitutionalPart = "has_constitutional_part"
  /// Has consumer friendly form
  case hasConsumerFriendlyForm = "has_consumer_friendly_form"
  /// Has context binding
  case hasContextBinding = "has_context_binding"
  /// Has continuation branch
  case hasContinuationBranch = "has_continuation_branch"
  /// Has contraindicated class
  case hasContraindicatedClass = "has_contraindicated_class"
  /// Has contraindicated drug
  case hasContraindicatedDrug = "has_contraindicated_drug"
  /// Has contraindicated mechanism of action
  case hasContraindicatedMechanismOfAction = "has_contraindicated_mechanism_of_action"
  /// Has contraindicated physiologic effect
  case hasContraindicatedPhysiologicEffect = "has_contraindicated_physiologic_effect"
  /// Has count of active ingredient
  case hasCountOfActiveIngredient = "has_count_of_active_ingredient"
  /// Has count of base of active ingredient
  case hasCountOfBaseOfActiveIngredient = "has_count_of_base_of_active_ingredient"
  /// Has count
  case hasCount = "has_count"
  /// Has course
  case hasCourse = "has_course"
  /// has ctcae_5 parent
  case hasCtcae5Parent = "has_ctcae_5_parent"
  /// has ctdc value
  case hasCtdcValue = "has_ctdc_value"
  /// has data element
  case hasDataElement = "has_data_element"
  /// Has default inpatient classification
  case hasDefaultInpatientClassification = "has_default_inpatient_classification"
  /// Has default outpatient classification
  case hasDefaultOutpatientClassification = "has_default_outpatient_classification"
  /// Has defining characteristic
  case hasDefiningCharacteristic = "has_defining_characteristic"
  /// Has definitional manifestation
  case hasDefinitionalManifestation = "has_definitional_manifestation"
  /// Has degree
  case hasDegree = "has_degree"
  /// Has dependent
  case hasDependent = "has_dependent"
  /// has development type
  case hasDevelopmentType = "has_development_type"
  /// has developmental stage
  case hasDevelopmentalStage = "has_developmental_stage"
  /// Has device characteristic
  case hasDeviceCharacteristic = "has_device_characteristic"
  /// Has device intended site
  case hasDeviceIntendedSite = "has_device_intended_site"
  /// ICD has DSM-5 diagnostic criteria
  case hasDiagnosticCriteria = "has_diagnostic_criteria"
  /// has dipg dmg permissible value
  case hasDipgDmgPermissibleValue = "has_dipg_dmg_permissible_value"
  /// has direct cell shape
  case hasDirectCellShape = "has_direct_cell_shape"
  /// Has direct device
  case hasDirectDevice = "has_direct_device"
  /// Has direct morphology
  case hasDirectMorphology = "has_direct_morphology"
  /// Has direct procedure site
  case hasDirectProcedureSite = "has_direct_procedure_site"
  /// Has direct site
  case hasDirectSite = "has_direct_site"
  /// Has direct substance
  case hasDirectSubstance = "has_direct_substance"
  /// Has disposition
  case hasDisposition = "has_disposition"
  /// Has divisor
  case hasDivisor = "has_divisor"
  /// Has dose form administration method
  case hasDoseFormAdministrationMethod = "has_dose_form_administration_method"
  /// Has dose form intended site
  case hasDoseFormIntendedSite = "has_dose_form_intended_site"
  /// Has dose form release characteristic
  case hasDoseFormReleaseCharacteristic = "has_dose_form_release_characteristic"
  /// Has dose form transformation
  case hasDoseFormTransformation = "has_dose_form_transformation"
  /// Has dose form
  case hasDoseForm = "has_dose_form"
  /// Has dose form group
  case hasDoseformgroup = "has_doseformgroup"
  /// Has entire anatomy structure
  case hasEntireAnatomyStructure = "has_entire_anatomy_structure"
  /// Has entry term
  case hasEntryTerm = "has_entry_term"
  /// Has entry version
  case hasEntryVersion = "has_entry_version"
  /// Has episodicity
  case hasEpisodicity = "has_episodicity"
  /// Has evaluation
  case hasEvaluation = "has_evaluation"
  /// Has exam
  case hasExam = "has_exam"
  /// Has excluded approach
  case hasExcludedApproach = "has_excluded_approach"
  /// Has excluded associated finding
  case hasExcludedAssociatedFinding = "has_excluded_associated_finding"
  /// Has excluded associated procedure
  case hasExcludedAssociatedProcedure = "has_excluded_associated_procedure"
  /// Has excluded component
  case hasExcludedComponent = "has_excluded_component"
  /// Has excluded locale
  case hasExcludedLocale = "has_excluded_locale"
  /// Has excluded method
  case hasExcludedMethod = "has_excluded_method"
  /// Has excluded pathology
  case hasExcludedPathology = "has_excluded_pathology"
  /// Has excluded patient type
  case hasExcludedPatientType = "has_excluded_patient_type"
  /// Has excluded procedure device
  case hasExcludedProcedureDevice = "has_excluded_procedure_device"
  /// Has excluded procedure site
  case hasExcludedProcedureSite = "has_excluded_procedure_site"
  /// Has excluded route of administration
  case hasExcludedRouteOfAdministration = "has_excluded_route_of_administration"
  /// Has excluded specimen
  case hasExcludedSpecimen = "has_excluded_specimen"
  /// Has excluded surgical extent
  case hasExcludedSurgicalExtent = "has_excluded_surgical_extent"
  /// Has expanded form
  case hasExpandedForm = "has_expanded_form"
  /// Has expected outcome
  case hasExpectedOutcome = "has_expected_outcome"
  /// Has extent
  case hasExtent = "has_extent"
  /// Has filling
  case hasFilling = "has_filling"
  /// Has finding context
  case hasFindingContext = "has_finding_context"
  /// Has finding informer
  case hasFindingInformer = "has_finding_informer"
  /// Has finding method
  case hasFindingMethod = "has_finding_method"
  /// Has finding site
  case hasFindingSite = "has_finding_site"
  /// Has focus
  case hasFocus = "has_focus"
  /// Has form
  case hasForm = "has_form"
  /// has free acid or base form
  case hasFreeAcidOrBaseForm = "has_free_acid_or_base_form"
  /// has full grown phenotype
  case hasFullGrownPhenotype = "has_full_grown_phenotype"
  /// has fusion
  case hasFusion = "has_fusion"
  /// has gdc value
  case hasGdcValue = "has_gdc_value"
  /// has gene product element
  case hasGeneProductElement = "has_gene_product_element"
  /// Has germ origin
  case hasGermOrigin = "has_germ_origin"
  /// Has given pharmaceutical substance
  case hasGivenPharmaceuticalSubstance = "has_given_pharmaceutical_substance"
  /// has grade
  case hasGrade = "has_grade"
  /// has icdc value
  case hasIcdcValue = "has_icdc_value"
  /// Has imaged location
  case hasImagedLocation = "has_imaged_location"
  /// Has imaging focus
  case hasImagingFocus = "has_imaging_focus"
  /// Has Inactive Ingredient
  case hasInactiveIngredient = "has_inactive_ingredient"
  /// has inc parent
  case hasIncParent = "has_inc_parent"
  /// Has indirect device
  case hasIndirectDevice = "has_indirect_device"
  /// Has indirect morphology
  case hasIndirectMorphology = "has_indirect_morphology"
  /// Has indirect procedure site
  case hasIndirectProcedureSite = "has_indirect_procedure_site"
  /// Has ingredient characteristic
  case hasIngredientCharacteristic = "has_ingredient_characteristic"
  /// Has ingredient qualitative strength
  case hasIngredientQualitativeStrength = "has_ingredient_qualitative_strength"
  /// Has ingredients
  case hasIngredients = "has_ingredients"
  /// Has ingredient
  case hasIngredient = "has_ingredient"
  /// Has inherent 3-D shape
  case hasInherent3dShape = "has_inherent_3d_shape"
  /// Has inherent attribute
  case hasInherentAttribute = "has_inherent_attribute"
  /// Has inherent location
  case hasInherentLocation = "has_inherent_location"
  /// Has inheritance type
  case hasInheritanceType = "has_inheritance_type"
  /// has insertion
  case hasInsertion = "has_insertion"
  /// Has instrumentation
  case hasInstrumentation = "has_instrumentation"
  /// Has intent
  case hasIntent = "has_intent"
  /// Has interpretation
  case hasInterpretation = "has_interpretation"
  /// Has lab number
  case hasLabNumber = "has_lab_number"
  /// Has lateral anatomic location
  case hasLateralAnatomicLocation = "has_lateral_anatomic_location"
  /// Has lateral location presence
  case hasLateralLocationPresence = "has_lateral_location_presence"
  /// Has laterality
  case hasLaterality = "has_laterality"
  /// Has life circumstance
  case hasLifeCircumstance = "has_life_circumstance"
  /// Has locale
  case hasLocale = "has_locale"
  /// Has location
  case hasLocation = "has_location"
  /// Has Loinc number
  case hasLoincNumber = "has_loinc_number"
  /// Has lymphatic drainage
  case hasLymphaticDrainage = "has_lymphatic_drainage"
  /// has maneuver type
  case hasManeuverType = "has_maneuver_type"
  /// Has manifestation
  case hasManifestation = "has_manifestation"
  /// Has mapping qualifier
  case hasMappingQualifier = "has_mapping_qualifier"
  /// Has measured component
  case hasMeasuredComponent = "has_measured_component"
  /// Has measurement method
  case hasMeasurementMethod = "has_measurement_method"
  /// Has mechanism of action
  case hasMechanismOfAction = "has_mechanism_of_action"
  /// Has member
  case hasMember = "has_member"
  /// Has method
  case hasMethod = "has_method"
  /// Has modality subtype
  case hasModalitySubtype = "has_modality_subtype"
  /// has modality type
  case hasModalityType = "has_modality_type"
  /// Has modification
  case hasModification = "has_modification"
  /// Has multi-level category
  case hasMultiLevelCategory = "has_multi_level_category"
  /// Has nerve supply
  case hasNerveSupply = "has_nerve_supply"
  /// Has object guidance
  case hasObjectGuidance = "has_object_guidance"
  /// has observed anatomical entity
  case hasObservedAnatomicalEntity = "has_observed_anatomical_entity"
  /// Has occurrence
  case hasOccurrence = "has_occurrence"
  /// Has onset
  case hasOnset = "has_onset"
  /// Has origin
  case hasOrigin = "has_origin"
  /// Has owning affiliate
  case hasOwningAffiliate = "has_owning_affiliate"
  /// Has owning section
  case hasOwningSection = "has_owning_section"
  /// Has owning subsection
  case hasOwningSubsection = "has_owning_subsection"
  /// CPT laboratory panel code has laboratory panel test member
  case hasPanelElement = "has_panel_element"
  /// Has parent group
  case hasParentGroup = "has_parent_group"
  /// Has parent
  case hasParent = "has_parent"
  /// Has part anatomy structure
  case hasPartAnatomyStructure = "has_part_anatomy_structure"
  /// Has part
  case hasPart = "has_part"
  /// Has pathological process
  case hasPathologicalProcess = "has_pathological_process"
  /// Has pathology
  case hasPathology = "has_pathology"
  /// Has patient type
  case hasPatientType = "has_patient_type"
  /// has pcdc all permissible value
  case hasPcdcAllPermissibleValue = "has_pcdc_all_permissible_value"
  /// has pcdc aml permissible value
  case hasPcdcAmlPermissibleValue = "has_pcdc_aml_permissible_value"
  /// has pcdc data type
  case hasPcdcDataType = "has_pcdc_data_type"
  /// has pcdc ews permissible value
  case hasPcdcEwsPermissibleValue = "has_pcdc_ews_permissible_value"
  /// has pcdc gct permissible value
  case hasPcdcGctPermissibleValue = "has_pcdc_gct_permissible_value"
  /// has pcdc hl permissible value
  case hasPcdcHlPermissibleValue = "has_pcdc_hl_permissible_value"
  /// has pcdc os permissible value
  case hasPcdcOsPermissibleValue = "has_pcdc_os_permissible_value"
  /// Has permuted term
  case hasPermutedTerm = "has_permuted_term"
  /// has pharmaceutical administration method
  case hasPharmaceuticalAdministrationMethod = "has_pharmaceutical_administration_method"
  /// has pharmaceutical basic dose form
  case hasPharmaceuticalBasicDoseForm = "has_pharmaceutical_basic_dose_form"
  /// has pharmaceutical intended site
  case hasPharmaceuticalIntendedSite = "has_pharmaceutical_intended_site"
  /// has pharmaceutical release characteristics
  case hasPharmaceuticalReleaseCharacteristics = "has_pharmaceutical_release_characteristics"
  /// Has_pharmaceutical_route
  case hasPharmaceuticalRoute = "has_pharmaceutical_route"
  /// has pharmaceutical state of matter
  case hasPharmaceuticalStateOfMatter = "has_pharmaceutical_state_of_matter"
  /// has pharmaceutical transformation
  case hasPharmaceuticalTransformation = "has_pharmaceutical_transformation"
  /// Has pharmacokinetics
  case hasPharmacokinetics = "has_pharmacokinetics"
  /// Has phenotype
  case hasPhenotype = "has_phenotype"
  /// has physical part of anatomic structure
  case hasPhysicalPartOfAnatomicStructure = "has_physical_part_of_anatomic_structure"
  /// Has physiologic effect
  case hasPhysiologicEffect = "has_physiologic_effect"
  /// Has physiologic state
  case hasPhysiologicState = "has_physiologic_state"
  /// Has possibly included approach
  case hasPossiblyIncludedApproach = "has_possibly_included_approach"
  /// Has possibly included associated finding
  case hasPossiblyIncludedAssociatedFinding = "has_possibly_included_associated_finding"
  /// Has possibly included associated procedure
  case hasPossiblyIncludedAssociatedProcedure = "has_possibly_included_associated_procedure"
  /// Has possibly included component
  case hasPossiblyIncludedComponent = "has_possibly_included_component"
  /// Has possibly included method
  case hasPossiblyIncludedMethod = "has_possibly_included_method"
  /// CPT laboratory panel code has possibly included laboratory panel test member
  case hasPossiblyIncludedPanelElement = "has_possibly_included_panel_element"
  /// Has possibly included pathology
  case hasPossiblyIncludedPathology = "has_possibly_included_pathology"
  /// Has possibly included patient type
  case hasPossiblyIncludedPatientType = "has_possibly_included_patient_type"
  /// Has possibly included procedure device
  case hasPossiblyIncludedProcedureDevice = "has_possibly_included_procedure_device"
  /// Has possibly included procedure site
  case hasPossiblyIncludedProcedureSite = "has_possibly_included_procedure_site"
  /// Has possibly included route of administration
  case hasPossiblyIncludedRouteOfAdministration = "has_possibly_included_route_of_administration"
  /// Has possibly included surgical extent
  case hasPossiblyIncludedSurgicalExtent = "has_possibly_included_surgical_extent"
  /// Has precise active ingredient
  case hasPreciseActiveIngredient = "has_precise_active_ingredient"
  /// Has precise ingredient
  case hasPreciseIngredient = "has_precise_ingredient"
  /// Has precondition
  case hasPrecondition = "has_precondition"
  /// Has presence guidance
  case hasPresenceGuidance = "has_presence_guidance"
  /// Has presentation strength denominator unit
  case hasPresentationStrengthDenominatorUnit = "has_presentation_strength_denominator_unit"
  /// Has presentation strength denominator value
  case hasPresentationStrengthDenominatorValue = "has_presentation_strength_denominator_value"
  /// Has presentation strength numerator unit
  case hasPresentationStrengthNumeratorUnit = "has_presentation_strength_numerator_unit"
  /// Has presentation strength numerator value
  case hasPresentationStrengthNumeratorValue = "has_presentation_strength_numerator_value"
  /// Has previous name
  case hasPrevName = "has_prev_name"
  /// Has previous symbol
  case hasPrevSymbol = "has_prev_symbol"
  /// Has primary segmental supply
  case hasPrimarySegmentalSupply = "has_primary_segmental_supply"
  /// Has print name
  case hasPrintName = "has_print_name"
  /// Has priority
  case hasPriority = "has_priority"
  /// Has procedure context
  case hasProcedureContext = "has_procedure_context"
  /// Has procedure device
  case hasProcedureDevice = "has_procedure_device"
  /// Has procedure morphology
  case hasProcedureMorphology = "has_procedure_morphology"
  /// Has procedure site
  case hasProcedureSite = "has_procedure_site"
  /// Has process duration
  case hasProcessDuration = "has_process_duration"
  /// Has process output
  case hasProcessOutput = "has_process_output"
  /// Has product characteristic
  case hasProductCharacteristic = "has_product_characteristic"
  /// has product monograph title
  case hasProductMonographTitle = "has_product_monograph_title"
  /// has projection
  case hasProjection = "has_projection"
  /// Has property type
  case hasPropertyType = "has_property_type"
  /// Has property
  case hasProperty = "has_property"
  /// Has quantified form
  case hasQuantifiedForm = "has_quantified_form"
  /// Has realization
  case hasRealization = "has_realization"
  /// Has recipient category
  case hasRecipientCategory = "has_recipient_category"
  /// Has regional part
  case hasRegionalPart = "has_regional_part"
  /// has related developmental entity
  case hasRelatedDevelopmentalEntity = "has_related_developmental_entity"
  /// Has related factor
  case hasRelatedFactor = "has_related_factor"
  /// Has result
  case hasResult = "has_result"
  /// Has revision status
  case hasRevisionStatus = "has_revision_status"
  /// Has risk factor
  case hasRiskFactor = "has_risk_factor"
  /// Has route of administration
  case hasRouteOfAdministration = "has_route_of_administration"
  /// has salt form
  case hasSaltForm = "has_salt_form"
  /// Has scale type
  case hasScaleType = "has_scale_type"
  /// Has scale
  case hasScale = "has_scale"
  /// Has secondary segmental supply
  case hasSecondarySegmentalSupply = "has_secondary_segmental_supply"
  /// Has segmental composition
  case hasSegmentalComposition = "has_segmental_composition"
  /// Has segmental supply
  case hasSegmentalSupply = "has_segmental_supply"
  /// has seronet permissible value
  case hasSeronetPermissibleValue = "has_seronet_permissible_value"
  /// Has severity
  case hasSeverity = "has_severity"
  /// Has sign or symptom
  case hasSignOrSymptom = "has_sign_or_symptom"
  /// Has single level category
  case hasSingleLevelCategory = "has_single_level_category"
  /// Has sort version
  case hasSortVersion = "has_sort_version"
  /// Has specialty
  case hasSpecialty = "has_specialty"
  /// Has specimen procedure
  case hasSpecimenProcedure = "has_specimen_procedure"
  /// Has specimen source identity
  case hasSpecimenSourceIdentity = "has_specimen_source_identity"
  /// Has specimen source morphology
  case hasSpecimenSourceMorphology = "has_specimen_source_morphology"
  /// Has specimen source topography
  case hasSpecimenSourceTopography = "has_specimen_source_topography"
  /// Has specimen substance
  case hasSpecimenSubstance = "has_specimen_substance"
  /// Has specimen
  case hasSpecimen = "has_specimen"
  /// Has stage
  case hasStage = "has_stage"
  /// Has state of matter
  case hasStateOfMatter = "has_state_of_matter"
  /// Structural class of
  case hasStructuralClass = "has_structural_class"
  /// Has subject of information
  case hasSubjectOfInformation = "has_subject_of_information"
  /// Has subject relationship context
  case hasSubjectRelationshipContext = "has_subject_relationship_context"
  /// Has subject
  case hasSubject = "has_subject"
  /// Has suffix
  case hasSuffix = "has_suffix"
  /// Has supersystem
  case hasSupersystem = "has_supersystem"
  /// Has supported concept property
  case hasSupportedConceptProperty = "has_supported_concept_property"
  /// Has supported concept relationship
  case hasSupportedConceptRelationship = "has_supported_concept_relationship"
  /// Has surface characteristic
  case hasSurfaceCharacteristic = "has_surface_characteristic"
  /// Has surface texture
  case hasSurfaceTexture = "has_surface_texture"
  /// has surgical approach
  case hasSurgicalApproach = "has_surgical_approach"
  /// Has surgical extent
  case hasSurgicalExtent = "has_surgical_extent"
  /// Has system
  case hasSystem = "has_system"
  /// Has target population
  case hasTargetPopulation = "has_target_population"
  /// has target
  case hasTarget = "has_target"
  /// Has technique
  case hasTechnique = "has_technique"
  /// Has temporal context
  case hasTemporalContext = "has_temporal_context"
  /// Has therapeutic class
  case hasTherapeuticClass = "has_therapeutic_class"
  /// Has time aspect
  case hasTimeAspect = "has_time_aspect"
  /// Has time modifier
  case hasTimeModifier = "has_time_modifier"
  /// Has timing of
  case hasTimingOf = "has_timing_of"
  /// Has tradename
  case hasTradename = "has_tradename"
  /// Has tributary
  case hasTributary = "has_tributary"
  /// Has unit of presentation
  case hasUnitOfPresentation = "has_unit_of_presentation"
  /// Has units
  case hasUnits = "has_units"
  /// Has venous drainage
  case hasVenousDrainage = "has_venous_drainage"
  /// Has version
  case hasVersion = "has_version"
  /// Has view type
  case hasViewType = "has_view_type"
  /// Homonym for
  case homonymFor = "homonym_for"
  /// Homonym of
  case homonymOf = "homonym_of"
  /// human disease maps to eo disease
  case humanDiseaseMapsToEoDisease = "human_disease_maps_to_eo_disease"
  /// ICD asterisk
  case icdAsterisk = "icd_asterisk"
  /// ICD dagger
  case icdDagger = "icd_dagger"
  /// icdc value of
  case icdcValueOf = "icdc_value_of"
  /// imaged anatomy has procedure
  case imagedAnatomyHasProcedure = "imaged_anatomy_has_procedure"
  /// Inactive Ingredient Of
  case inactiveIngredientOf = "inactive_ingredient_of"
  /// inc parent of
  case incParentOf = "inc_parent_of"
  /// included_in
  case includedIn = "included_in"
  /// Includes sub specimen
  case includesSubSpecimen = "includes_sub_specimen"
  /// includes
  case includes = "includes"
  /// Indirect device of
  case indirectDeviceOf = "indirect_device_of"
  /// Indirect morphology of
  case indirectMorphologyOf = "indirect_morphology_of"
  /// Indirect procedure site of
  case indirectProcedureSiteOf = "indirect_procedure_site_of"
  /// Induced by
  case inducedBy = "induced_by"
  /// inferior to
  case inferiorTo = "inferior_to"
  /// inferolateral to
  case inferolateralTo = "inferolateral_to"
  /// inferomedial to
  case inferomedialTo = "inferomedial_to"
  /// Ingredient characteristic of
  case ingredientCharacteristicOf = "ingredient_characteristic_of"
  /// Ingredient of
  case ingredientOf = "ingredient_of"
  /// Ingredient qualitative strength of
  case ingredientQualitativeStrengthOf = "ingredient_qualitative_strength_of"
  /// Ingredients of
  case ingredientsOf = "ingredients_of"
  /// Inherent 3-D shape of
  case inherent3dShapeOf = "inherent_3d_shape_of"
  /// Inherent location of
  case inherentLocationOf = "inherent_location_of"
  /// Inheres in
  case inheresIn = "inheres_in"
  /// Inheritance type of
  case inheritanceTypeOf = "inheritance_type_of"
  /// insertion of
  case insertionOf = "insertion_of"
  /// Instrumentation of
  case instrumentationOf = "instrumentation_of"
  /// Intent of
  case intentOf = "intent_of"
  /// internal to
  case internalTo = "internal_to"
  /// Interpretation of
  case interpretationOf = "interpretation_of"
  /// Interprets
  case interprets = "interprets"
  /// Inverse during
  case inverseDuring = "inverse_during"
  /// Inverse ends during
  case inverseEndsDuring = "inverse_ends_during"
  /// Inverse happens during
  case inverseHappensDuring = "inverse_happens_during"
  /// Inverse is a
  case inverseIsa = "inverse_isa"
  /// Inverse relative to
  case inverseRelativeTo = "inverse_relative_to"
  /// Inverse was a
  case inverseWasA = "inverse_was_a"
  /// is abnormal cell of disease
  case isAbnormalCellOfDisease = "is_abnormal_cell_of_disease"
  /// is abnormality of gene product
  case isAbnormalityOfGeneProduct = "is_abnormality_of_gene_product"
  /// is abnormality of gene
  case isAbnormalityOfGene = "is_abnormality_of_gene"
  /// Is action guidance for
  case isActionGuidanceFor = "is_action_guidance_for"
  /// Is aggregation view of
  case isAggregationViewOf = "is_aggregation_view_of"
  /// Is approach guidance for
  case isApproachGuidanceFor = "is_approach_guidance_for"
  /// is associated anatomic site of
  case isAssociatedAnatomicSiteOf = "is_associated_anatomic_site_of"
  /// is associated anatomy of gene product
  case isAssociatedAnatomyOfGeneProduct = "is_associated_anatomy_of_gene_product"
  /// is associated disease of
  case isAssociatedDiseaseOf = "is_associated_disease_of"
  /// is biochemical function of gene product
  case isBiochemicalFunctionOfGeneProduct = "is_biochemical_function_of_gene_product"
  /// is chemical classification of gene product
  case isChemicalClassificationOfGeneProduct = "is_chemical_classification_of_gene_product"
  /// is chromosomal location of gene
  case isChromosomalLocationOfGene = "is_chromosomal_location_of_gene"
  /// is component of chemotherapy regimen
  case isComponentOfChemotherapyRegimen = "is_component_of_chemotherapy_regimen"
  /// is ctdc value of
  case isCtdcValueOf = "is_ctdc_value_of"
  /// is cytogenetic abnormality of disease
  case isCytogeneticAbnormalityOfDisease = "is_cytogenetic_abnormality_of_disease"
  /// is dipg dmg permissible value for variable
  case isDipgDmgPermissibleValueForVariable = "is_dipg_dmg_permissible_value_for_variable"
  /// Is exam for
  case isExamFor = "is_exam_for"
  /// is finding of disease
  case isFindingOfDisease = "is_finding_of_disease"
  /// Is given pharmaceutical substance for
  case isGivenPharmaceuticalSubstanceFor = "is_given_pharmaceutical_substance_for"
  /// is grade of disease
  case isGradeOfDisease = "is_grade_of_disease"
  /// Is imaged location for
  case isImagedLocationFor = "is_imaged_location_for"
  /// Is imaging focus of
  case isImagingFocusOf = "is_imaging_focus_of"
  /// Is interpreted by
  case isInterpretedBy = "is_interpreted_by"
  /// Is lateral anatomic location of
  case isLateralAnatomicLocationOf = "is_lateral_anatomic_location_of"
  /// is location of anatomic structure
  case isLocationOfAnatomicStructure = "is_location_of_anatomic_structure"
  /// is location of biological process
  case isLocationOfBiologicalProcess = "is_location_of_biological_process"
  /// Is maneuver type for
  case isManeuverTypeFor = "is_maneuver_type_for"
  /// is marked by gene product
  case isMarkedByGeneProduct = "is_marked_by_gene_product"
  /// is mechanism of action of chemical or drug
  case isMechanismOfActionOfChemicalOrDrug = "is_mechanism_of_action_of_chemical_or_drug"
  /// is metastatic anatomic site of disease
  case isMetastaticAnatomicSiteOfDisease = "is_metastatic_anatomic_site_of_disease"
  /// Is modality subtype for
  case isModalitySubtypeFor = "is_modality_subtype_for"
  /// Is modality type for
  case isModalityTypeFor = "is_modality_type_for"
  /// Is modification of
  case isModificationOf = "is_modification_of"
  /// is molecular abnormality of disease
  case isMolecularAbnormalityOfDisease = "is_molecular_abnormality_of_disease"
  /// is normal cell origin of disease
  case isNormalCellOriginOfDisease = "is_normal_cell_origin_of_disease"
  /// is normal tissue origin of disease
  case isNormalTissueOriginOfDisease = "is_normal_tissue_origin_of_disease"
  /// is not abnormal cell of disease
  case isNotAbnormalCellOfDisease = "is_not_abnormal_cell_of_disease"
  /// is not cytogenetic abnormality of disease
  case isNotCytogeneticAbnormalityOfDisease = "is_not_cytogenetic_abnormality_of_disease"
  /// is not finding of disease
  case isNotFindingOfDisease = "is_not_finding_of_disease"
  /// is not metastatic anatomic site of disease
  case isNotMetastaticAnatomicSiteOfDisease = "is_not_metastatic_anatomic_site_of_disease"
  /// is not molecular abnormality of disease
  case isNotMolecularAbnormalityOfDisease = "is_not_molecular_abnormality_of_disease"
  /// is not normal cell origin of disease
  case isNotNormalCellOriginOfDisease = "is_not_normal_cell_origin_of_disease"
  /// is not normal tissue origin of disease
  case isNotNormalTissueOriginOfDisease = "is_not_normal_tissue_origin_of_disease"
  /// is not primary anatomic site of disease
  case isNotPrimaryAnatomicSiteOfDisease = "is_not_primary_anatomic_site_of_disease"
  /// Is object guidance for
  case isObjectGuidanceFor = "is_object_guidance_for"
  /// is organism source of gene product
  case isOrganismSourceOfGeneProduct = "is_organism_source_of_gene_product"
  /// is paired with value set
  case isPairedWithValueSet = "is_paired_with_value_set"
  /// is pcdc all permissible value for variable
  case isPcdcAllPermissibleValueForVariable = "is_pcdc_all_permissible_value_for_variable"
  /// is pcdc aml permissible value for variable
  case isPcdcAmlPermissibleValueForVariable = "is_pcdc_aml_permissible_value_for_variable"
  /// is pcdc ews permissible value for variable
  case isPcdcEwsPermissibleValueForVariable = "is_pcdc_ews_permissible_value_for_variable"
  /// is pcdc gct permissible value for variable
  case isPcdcGctPermissibleValueForVariable = "is_pcdc_gct_permissible_value_for_variable"
  /// is pcdc hl permissible value for variable
  case isPcdcHlPermissibleValueForVariable = "is_pcdc_hl_permissible_value_for_variable"
  /// is pcdc os permissible value for variable
  case isPcdcOsPermissibleValueForVariable = "is_pcdc_os_permissible_value_for_variable"
  /// Is pharmaceutical route for
  case isPharmaceuticalRouteFor = "is_pharmaceutical_route_for"
  /// is physical location of gene
  case isPhysicalLocationOfGene = "is_physical_location_of_gene"
  /// is physiologic effect of chemical or drug
  case isPhysiologicEffectOfChemicalOrDrug = "is_physiologic_effect_of_chemical_or_drug"
  /// Is presence guidance for
  case isPresenceGuidanceFor = "is_presence_guidance_for"
  /// Is presence of lateral location
  case isPresenceOfLateralLocation = "is_presence_of_lateral_location"
  /// is primary anatomic site of disease
  case isPrimaryAnatomicSiteOfDisease = "is_primary_anatomic_site_of_disease"
  /// is property or attribute of eo disease
  case isPropertyOrAttributeOfEoDisease = "is_property_or_attribute_of_eo_disease"
  /// is qualified by
  case isQualifiedBy = "is_qualified_by"
  /// Is Related To Endogenous Product
  case isRelatedToEndogenousProduct = "is_related_to_endogenous_product"
  /// is seronet permissible value for variable
  case isSeronetPermissibleValueForVariable = "is_seronet_permissible_value_for_variable"
  /// is stage of disease
  case isStageOfDisease = "is_stage_of_disease"
  /// Is sterile
  case isSterile = "is_sterile"
  /// is structural domain or motif of gene product
  case isStructuralDomainOrMotifOfGeneProduct = "is_structural_domain_or_motif_of_gene_product"
  /// Is subject of
  case isSubjectOf = "is_subject_of"
  /// is target
  case isTarget = "is_target"
  /// Is timing for
  case isTimingFor = "is_timing_for"
  /// is value for gdc property
  case isValueForGdcProperty = "is_value_for_gdc_property"
  /// Is view type for
  case isViewTypeFor = "is_view_type_for"
  /// Is a
  case isa = "isa"
  /// kind is domain of
  case kindIsDomainOf = "kind_is_domain_of"
  /// kind is range of
  case kindIsRangeOf = "kind_is_range_of"
  /// Lab number
  case labNumberOf = "lab_number_of"
  /// Larger Than
  case largerThan = "larger_than"
  /// lateral to
  case lateralTo = "lateral_to"
  /// Laterality of
  case lateralityOf = "laterality_of"
  /// left lateral to
  case leftLateralTo = "left_lateral_to"
  /// left medial to
  case leftMedialTo = "left_medial_to"
  /// Life circumstance of
  case lifeCircumstanceOf = "life_circumstance_of"
  /// Locale of excluded
  case localeOfExcluded = "locale_of_excluded"
  /// Locale of
  case localeOf = "locale_of"
  /// Location of
  case locationOf = "location_of"
  /// Loinc number of
  case loincNumberOf = "loinc_number_of"
  /// Lymphatic drainage of
  case lymphaticDrainageOf = "lymphatic_drainage_of"
  /// Manifestation of
  case manifestationOf = "manifestation_of"
  /// manufactured by
  case manufacturedBy = "manufactured_by"
  /// manufactures
  case manufactures = "manufactures"
  /// Mapped from
  case mappedFrom = "mapped_from"
  /// Mapped to
  case mappedTo = "mapped_to"
  /// Mapping qualifier of
  case mappingQualifierOf = "mapping_qualifier_of"
  /// matures from
  case maturesFrom = "matures_from"
  /// matures into
  case maturesInto = "matures_into"
  /// may be abnormal cell of disease
  case mayBeAbnormalCellOfDisease = "may_be_abnormal_cell_of_disease"
  /// may be associated disease of disease
  case mayBeAssociatedDiseaseOfDisease = "may_be_associated_disease_of_disease"
  /// may be cytogenetic abnormality of disease
  case mayBeCytogeneticAbnormalityOfDisease = "may_be_cytogenetic_abnormality_of_disease"
  /// May be diagnosed by
  case mayBeDiagnosedBy = "may_be_diagnosed_by"
  /// may be finding of disease
  case mayBeFindingOfDisease = "may_be_finding_of_disease"
  /// may be molecular abnormality of disease
  case mayBeMolecularAbnormalityOfDisease = "may_be_molecular_abnormality_of_disease"
  /// may be normal cell origin of disease
  case mayBeNormalCellOriginOfDisease = "may_be_normal_cell_origin_of_disease"
  /// may be normal tissue origin of disease
  case mayBeNormalTissueOriginOfDisease = "may_be_normal_tissue_origin_of_disease"
  /// May be prevented by
  case mayBePreventedBy = "may_be_prevented_by"
  /// May be qualified by
  case mayBeQualifiedBy = "may_be_qualified_by"
  /// May be treated by
  case mayBeTreatedBy = "may_be_treated_by"
  /// May diagnose
  case mayDiagnose = "may_diagnose"
  /// May inhibit effect of
  case mayInhibitEffectOf = "may_inhibit_effect_of"
  /// May prevent
  case mayPrevent = "may_prevent"
  /// May qualify
  case mayQualify = "may_qualify"
  /// May treat
  case mayTreat = "may_treat"
  /// Measured by
  case measuredBy = "measured_by"
  /// Measured component of
  case measuredComponentOf = "measured_component_of"
  /// Measurement method of
  case measurementMethodOf = "measurement_method_of"
  /// Measures
  case measures = "measures"
  /// Mechanism of action of
  case mechanismOfActionOf = "mechanism_of_action_of"
  /// medial to
  case medialTo = "medial_to"
  /// Member of
  case memberOf = "member_of"
  /// merges with
  case mergesWith = "merges_with"
  /// Metabolic site of
  case metabolicSiteOf = "metabolic_site_of"
  /// Method of excluded
  case methodOfExcluded = "method_of_excluded"
  /// Method of possibly included
  case methodOfPossiblyIncluded = "method_of_possibly_included"
  /// Method of
  case methodOf = "method_of"
  /// Modified by
  case modifiedBy = "modified_by"
  /// Modifies
  case modifies = "modifies"
  /// molecular abnormality involves gene
  case molecularAbnormalityInvolvesGene = "molecular_abnormality_involves_gene"
  /// Moved from
  case movedFrom = "moved_from"
  /// Moved to
  case movedTo = "moved_to"
  /// MTH British form of
  case mthBritishFormOf = "mth_british_form_of"
  /// MTH expanded form of
  case mthExpandedFormOf = "mth_expanded_form_of"
  /// MTH has British form
  case mthHasBritishForm = "mth_has_british_form"
  /// MTH has expanded form
  case mthHasExpandedForm = "mth_has_expanded_form"
  /// Has plain text form, Metathesaurus-asserted
  case mthHasPlainTextForm = "mth_has_plain_text_form"
  /// Has XML form, Metathesaurus-asserted
  case mthHasXmlForm = "mth_has_xml_form"
  /// Plain text form of, Metathesaurus-asserted
  case mthPlainTextFormOf = "mth_plain_text_form_of"
  /// XML form of, Metathesaurus-asserted
  case mthXmlFormOf = "mth_xml_form_of"
  /// Multiply mapped from
  case multiplyMappedFrom = "multiply_mapped_from"
  /// Multiply mapped to
  case multiplyMappedTo = "multiply_mapped_to"
  /// Negatively regulated by
  case negativelyRegulatedBy = "negatively_regulated_by"
  /// Negatively regulates
  case negativelyRegulates = "negatively_regulates"
  /// Neoplasm has special category
  case neoplasmHasSpecialCategory = "neoplasm_has_special_category"
  /// Nerve supply of
  case nerveSupplyOf = "nerve_supply_of"
  /// Noun form of
  case nounFormOf = "noun_form_of"
  /// Occurs after
  case occursAfter = "occurs_after"
  /// Occurs before
  case occursBefore = "occurs_before"
  /// Occurs in
  case occursIn = "occurs_in"
  /// Onset of
  case onsetOf = "onset_of"
  /// organism has gene
  case organismHasGene = "organism_has_gene"
  /// Origin of
  case originOf = "origin_of"
  /// Other mapped from
  case otherMappedFrom = "other_mapped_from"
  /// Other mapped to
  case otherMappedTo = "other_mapped_to"
  /// Owning affiliate of
  case owningAffiliateOf = "owning_affiliate_of"
  /// Owning section of
  case owningSectionOf = "owning_section_of"
  /// Owning subsection of
  case owningSubsectionOf = "owning_subsection_of"
  /// CPT laboratory panel test member is possibly included element of laboratory code
  case panelElementOfPossiblyIncluded = "panel_element_of_possibly_included"
  /// CPT laboratory panel test member is element of laboratory code
  case panelElementOf = "panel_element_of"
  /// Parent group of
  case parentGroupOf = "parent_group_of"
  /// Parent of
  case parentOf = "parent_of"
  /// Part anatomy structure of
  case partAnatomyStructureOf = "part_anatomy_structure_of"
  /// Part of
  case partOf = "part_of"
  /// Part referred to by
  case partReferredToBy = "part_referred_to_by"
  /// Partially equivalent to
  case partiallyEquivalentTo = "partially_equivalent_to"
  /// partially excised anatomy has procedure
  case partiallyExcisedAnatomyHasProcedure = "partially_excised_anatomy_has_procedure"
  /// partially excised anatomy may have procedure
  case partiallyExcisedAnatomyMayHaveProcedure = "partially_excised_anatomy_may_have_procedure"
  /// pathogenesis of disease involves gene
  case pathogenesisOfDiseaseInvolvesGene = "pathogenesis_of_disease_involves_gene"
  /// Pathological process of
  case pathologicalProcessOf = "pathological_process_of"
  /// Pathology of excluded
  case pathologyOfExcluded = "pathology_of_excluded"
  /// Pathology of possibly included
  case pathologyOfPossiblyIncluded = "pathology_of_possibly_included"
  /// Pathology of
  case pathologyOf = "pathology_of"
  /// pathway has gene element
  case pathwayHasGeneElement = "pathway_has_gene_element"
  /// Patient type of excluded
  case patientTypeOfExcluded = "patient_type_of_excluded"
  /// Patient type of possibly included
  case patientTypeOfPossiblyIncluded = "patient_type_of_possibly_included"
  /// Patient type of
  case patientTypeOf = "patient_type_of"
  /// pcdc data type of
  case pcdcDataTypeOf = "pcdc_data_type_of"
  /// Permuted term of
  case permutedTermOf = "permuted_term_of"
  /// pharmaceutical administration method of
  case pharmaceuticalAdministrationMethodOf = "pharmaceutical_administration_method_of"
  /// pharmaceutical basic dose form of
  case pharmaceuticalBasicDoseFormOf = "pharmaceutical_basic_dose_form_of"
  /// pharmaceutical intended site of
  case pharmaceuticalIntendedSiteOf = "pharmaceutical_intended_site_of"
  /// pharmaceutical release characteristics of
  case pharmaceuticalReleaseCharacteristicsOf = "pharmaceutical_release_characteristics_of"
  /// pharmaceutical state of matter of
  case pharmaceuticalStateOfMatterOf = "pharmaceutical_state_of_matter_of"
  /// pharmaceutical transformation_of
  case pharmaceuticalTransformationOf = "pharmaceutical_transformation_of"
  /// Pharmacokinetics of
  case pharmacokineticsOf = "pharmacokinetics_of"
  /// Phenotype of
  case phenotypeOf = "phenotype_of"
  /// Physiologic effect of
  case physiologicEffectOf = "physiologic_effect_of"
  /// Physiologic state of
  case physiologicStateOf = "physiologic_state_of"
  /// Place traveled from
  case placeTraveledFrom = "place_traveled_from"
  /// Place traveled to or resided in
  case placeTraveledTo = "place_traveled_to"
  /// Plays role
  case playsRole = "plays_role"
  /// Population at risk for
  case populationAtRiskFor = "population_at_risk_for"
  /// Positively regulated by
  case positivelyRegulatedBy = "positively_regulated_by"
  /// Positively regulates
  case positivelyRegulates = "positively_regulates"
  /// Possibly equivalent to
  case possiblyEquivalentTo = "possibly_equivalent_to"
  /// Possibly replaced by
  case possiblyReplacedBy = "possibly_replaced_by"
  /// Possibly replaces
  case possiblyReplaces = "possibly_replaces"
  /// posterior to
  case posteriorTo = "posterior_to"
  /// posteroinferior to
  case posteroinferiorTo = "posteroinferior_to"
  /// posterolateral to
  case posterolateralTo = "posterolateral_to"
  /// posteromedial to
  case posteromedialTo = "posteromedial_to"
  /// posterosuperior to
  case posterosuperiorTo = "posterosuperior_to"
  /// Precise active ingredient of
  case preciseActiveIngredientOf = "precise_active_ingredient_of"
  /// Precise ingredient of
  case preciseIngredientOf = "precise_ingredient_of"
  /// Precondition of
  case preconditionOf = "precondition_of"
  /// Presentation strength denominator unit of
  case presentationStrengthDenominatorUnitOf = "presentation_strength_denominator_unit_of"
  /// Presentation strength denominator value of
  case presentationStrengthDenominatorValueOf = "presentation_strength_denominator_value_of"
  /// Presentation strength numerator unit of
  case presentationStrengthNumeratorUnitOf = "presentation_strength_numerator_unit_of"
  /// Presentation strength numerator value of
  case presentationStrengthNumeratorValueOf = "presentation_strength_numerator_value_of"
  /// Previous name of
  case prevNameOf = "prev_name_of"
  /// Previous symbol of
  case prevSymbolOf = "prev_symbol_of"
  /// Primary mapped from
  case primaryMappedFrom = "primary_mapped_from"
  /// Primary mapped to
  case primaryMappedTo = "primary_mapped_to"
  /// Primary segmental supply of
  case primarySegmentalSupplyOf = "primary_segmental_supply_of"
  /// Print name of
  case printNameOf = "print_name_of"
  /// Priority of
  case priorityOf = "priority_of"
  /// Procedure context of
  case procedureContextOf = "procedure_context_of"
  /// Procedure device of excluded
  case procedureDeviceOfExcluded = "procedure_device_of_excluded"
  /// Procedure device of possibly included
  case procedureDeviceOfPossiblyIncluded = "procedure_device_of_possibly_included"
  /// Procedure device of
  case procedureDeviceOf = "procedure_device_of"
  /// procedure has completely excised anatomy
  case procedureHasCompletelyExcisedAnatomy = "procedure_has_completely_excised_anatomy"
  /// procedure has excised anatomy
  case procedureHasExcisedAnatomy = "procedure_has_excised_anatomy"
  /// procedure has imaged anatomy
  case procedureHasImagedAnatomy = "procedure_has_imaged_anatomy"
  /// procedure has partially excised anatomy
  case procedureHasPartiallyExcisedAnatomy = "procedure_has_partially_excised_anatomy"
  /// procedure has target anatomy
  case procedureHasTargetAnatomy = "procedure_has_target_anatomy"
  /// procedure may have completely excised anatomy
  case procedureMayHaveCompletelyExcisedAnatomy = "procedure_may_have_completely_excised_anatomy"
  /// procedure may have excised anatomy
  case procedureMayHaveExcisedAnatomy = "procedure_may_have_excised_anatomy"
  /// procedure may have partially excised anatomy
  case procedureMayHavePartiallyExcisedAnatomy = "procedure_may_have_partially_excised_anatomy"
  /// Procedure morphology of
  case procedureMorphologyOf = "procedure_morphology_of"
  /// Procedure site of excluded
  case procedureSiteOfExcluded = "procedure_site_of_excluded"
  /// Procedure site of possibly included
  case procedureSiteOfPossiblyIncluded = "procedure_site_of_possibly_included"
  /// Procedure site of
  case procedureSiteOf = "procedure_site_of"
  /// Process acts on
  case processActsOn = "process_acts_on"
  /// process altered by allele
  case processAlteredByAllele = "process_altered_by_allele"
  /// Process duration of
  case processDurationOf = "process_duration_of"
  /// Process extends to
  case processExtendsTo = "process_extends_to"
  /// process includes biological process
  case processIncludesBiologicalProcess = "process_includes_biological_process"
  /// process initiates biological process
  case processInitiatesBiologicalProcess = "process_initiates_biological_process"
  /// process involves gene
  case processInvolvesGene = "process_involves_gene"
  /// Process output of
  case processOutputOf = "process_output_of"
  /// Product characteristic of
  case productCharacteristicOf = "product_characteristic_of"
  /// product monograph title of
  case productMonographTitleOf = "product_monograph_title_of"
  /// projects from
  case projectsFrom = "projects_from"
  /// projects to
  case projectsTo = "projects_to"
  /// Property of
  case propertyOf = "property_of"
  /// Property type of
  case propertyTypeOf = "property_type_of"
  /// proximal to
  case proximalTo = "proximal_to"
  /// qualifier applies to
  case qualifierAppliesTo = "qualifier_applies_to"
  /// Quantified form of
  case quantifiedFormOf = "quantified_form_of"
  /// Realization of
  case realizationOf = "realization_of"
  /// receives attachment from
  case receivesAttachmentFrom = "receives_attachment_from"
  /// receives drainage from
  case receivesDrainageFrom = "receives_drainage_from"
  /// Receives input from
  case receivesInputFrom = "receives_input_from"
  /// receives projection
  case receivesProjection = "receives_projection"
  /// Recipient category of
  case recipientCategoryOf = "recipient_category_of"
  /// referred to by
  case referredToBy = "referred_to_by"
  /// refers to
  case refersTo = "refers_to"
  /// Reformulated to
  case reformulatedTo = "reformulated_to"
  /// Reformulation of
  case reformulationOf = "reformulation_of"
  /// Regimen Has Accepted Use For Disease
  case regimenHasAcceptedUseForDisease = "regimen_has_accepted_use_for_disease"
  /// Regional part of
  case regionalPartOf = "regional_part_of"
  /// Regulated by
  case regulatedBy = "regulated_by"
  /// Regulates
  case regulates = "regulates"
  /// related developmental entity of
  case relatedDevelopmentalEntityOf = "related_developmental_entity_of"
  /// Related factor of
  case relatedFactorOf = "related_factor_of"
  /// related object
  case relatedObject = "related_object"
  /// related part
  case relatedPart = "related_part"
  /// related to genetic biomarker
  case relatedToGeneticBiomarker = "related_to_genetic_biomarker"
  /// Is Related to
  case relatedTo = "related_to"
  /// Relative to part of
  case relativeToPartOf = "relative_to_part_of"
  /// Relative to
  case relativeTo = "relative_to"
  /// Replaced by
  case replacedBy = "replaced_by"
  /// Replaces
  case replaces = "replaces"
  /// Result of
  case resultOf = "result_of"
  /// Revision status of
  case revisionStatusOf = "revision_status_of"
  /// right lateral to
  case rightLateralTo = "right_lateral_to"
  /// right medial to
  case rightMedialTo = "right_medial_to"
  /// Risk factor of
  case riskFactorOf = "risk_factor_of"
  /// role has domain
  case roleHasDomain = "role_has_domain"
  /// role has parent
  case roleHasParent = "role_has_parent"
  /// role has range
  case roleHasRange = "role_has_range"
  /// role is parent of
  case roleIsParentOf = "role_is_parent_of"
  /// Role played by
  case rolePlayedBy = "role_played_by"
  /// Route of administration of excluded
  case routeOfAdministrationOfExcluded = "route_of_administration_of_excluded"
  /// Route of administration of possibly included
  case routeOfAdministrationOfPossiblyIncluded = "route_of_administration_of_possibly_included"
  /// Route of administration of
  case routeOfAdministrationOf = "route_of_administration_of"
  /// Same as
  case sameAs = "same_as"
  /// Scale of
  case scaleOf = "scale_of"
  /// Scale type of
  case scaleTypeOf = "scale_type_of"
  /// Secondary segmental supply of
  case secondarySegmentalSupplyOf = "secondary_segmental_supply_of"
  /// See from
  case seeFrom = "see_from"
  /// See
  case see = "see"
  /// Segmental composition of
  case segmentalCompositionOf = "segmental_composition_of"
  /// Segmental supply of
  case segmentalSupplyOf = "segmental_supply_of"
  /// Sends output to
  case sendsOutputTo = "sends_output_to"
  /// Severity of
  case severityOf = "severity_of"
  /// Sign or symptom of
  case signOrSymptomOf = "sign_or_symptom_of"
  /// Site of metabolism
  case siteOfMetabolism = "site_of_metabolism"
  /// Smaller Than
  case smallerThan = "smaller_than"
  /// Sort version of
  case sortVersionOf = "sort_version_of"
  /// special category includes neoplasm
  case specialCategoryIncludesNeoplasm = "special_category_includes_neoplasm"
  /// Specialty of
  case specialtyOf = "specialty_of"
  /// Specimen of excluded
  case specimenOfExcluded = "specimen_of_excluded"
  /// Specimen of
  case specimenOf = "specimen_of"
  /// Specimen procedure of
  case specimenProcedureOf = "specimen_procedure_of"
  /// Specimen source identity of
  case specimenSourceIdentityOf = "specimen_source_identity_of"
  /// Specimen source morphology of
  case specimenSourceMorphologyOf = "specimen_source_morphology_of"
  /// specimen source topography of
  case specimenSourceTopographyOf = "specimen_source_topography_of"
  /// Specimen substance of
  case specimenSubstanceOf = "specimen_substance_of"
  /// scc
  case ssc = "ssc"
  /// Stage of
  case stageOf = "stage_of"
  /// State of matter of
  case stateOfMatterOf = "state_of_matter_of"
  /// Has structural class
  case structuralClassOf = "structural_class_of"
  /// Sub specimen included by
  case subSpecimenIncludedBy = "sub_specimen_included_by"
  /// Subject of information of
  case subjectOfInformationOf = "subject_of_information_of"
  /// Subject relationship context of
  case subjectRelationshipContextOf = "subject_relationship_context_of"
  /// subset includes concept
  case subsetIncludesConcept = "subset_includes_concept"
  /// Substance used by excluded
  case substanceUsedByExcluded = "substance_used_by_excluded"
  /// Substance used by possibly included
  case substanceUsedByPossiblyIncluded = "substance_used_by_possibly_included"
  /// Substance used by
  case substanceUsedBy = "substance_used_by"
  /// Suffix of
  case suffixOf = "suffix_of"
  /// superior to
  case superiorTo = "superior_to"
  /// superolateral to
  case superolateralTo = "superolateral_to"
  /// superomedial to
  case superomedialTo = "superomedial_to"
  /// Supersystem of
  case supersystemOf = "supersystem_of"
  /// Supported concept property in
  case supportedConceptPropertyIn = "supported_concept_property_in"
  /// Supported concept relationship in
  case supportedConceptRelationshipIn = "supported_concept_relationship_in"
  /// Surface characteristic of
  case surfaceCharacteristicOf = "surface_characteristic_of"
  /// Surface texture of
  case surfaceTextureOf = "surface_texture_of"
  /// surgical approach of
  case surgicalApproachOf = "surgical_approach_of"
  /// Surgical extent of excluded
  case surgicalExtentOfExcluded = "surgical_extent_of_excluded"
  /// Surgical extent of possibly included
  case surgicalExtentOfPossiblyIncluded = "surgical_extent_of_possibly_included"
  /// Surgical extent of
  case surgicalExtentOf = "surgical_extent_of"
  /// Surrounded by
  case surroundedBy = "surrounded_by"
  /// Surrounds
  case surrounds = "surrounds"
  /// System of
  case systemOf = "system_of"
  /// target anatomy has procedure
  case targetAnatomyHasProcedure = "target_anatomy_has_procedure"
  /// Target population of
  case targetPopulationOf = "target_population_of"
  /// Technique of
  case techniqueOf = "technique_of"
  /// Temporal context of
  case temporalContextOf = "temporal_context_of"
  /// Temporally followed by
  case temporallyFollowedBy = "temporally_followed_by"
  /// Temporally follows
  case temporallyFollows = "temporally_follows"
  /// Temporally related to
  case temporallyRelatedTo = "temporally_related_to"
  /// Therapeutic class of
  case therapeuticClassOf = "therapeutic_class_of"
  /// Time aspect of
  case timeAspectOf = "time_aspect_of"
  /// Time modifier of
  case timeModifierOf = "time_modifier_of"
  /// tissue is expression site of gene product
  case tissueIsExpressionSiteOfGeneProduct = "tissue_is_expression_site_of_gene_product"
  /// Tradename of
  case tradenameOf = "tradename_of"
  /// transforms from
  case transformsFrom = "transforms_from"
  /// transforms into
  case transformsInto = "transforms_into"
  /// Treated by
  case treatedBy = "treated_by"
  /// Treats
  case treats = "treats"
  /// Tributary of
  case tributaryOf = "tributary_of"
  /// Uniquely mapped from
  case uniquelyMappedFrom = "uniquely_mapped_from"
  /// Uniquely mapped to
  case uniquelyMappedTo = "uniquely_mapped_to"
  /// Unit of presentation of
  case unitOfPresentationOf = "unit_of_presentation_of"
  /// Units of
  case unitsOf = "units_of"
  /// Used by
  case usedBy = "used_by"
  /// Used for
  case usedFor = "used_for"
  /// Uses access device
  case usesAccessDevice = "uses_access_device"
  /// Uses device
  case usesDevice = "uses_device"
  /// Uses energy
  case usesEnergy = "uses_energy"
  /// Uses excluded substance
  case usesExcludedSubstance = "uses_excluded_substance"
  /// Uses possibly included substance
  case usesPossiblyIncludedSubstance = "uses_possibly_included_substance"
  /// Uses substance
  case usesSubstance = "uses_substance"
  /// Uses
  case uses = "uses"
  /// Use
  case use = "use"
  /// value set is paired with
  case valueSetIsPairedWith = "value_set_is_paired_with"
  /// Venous drainage of
  case venousDrainageOf = "venous_drainage_of"
  /// Version of
  case versionOf = "version_of"
  /// Was a
  case wasA = "was_a"
  /// Wound has communication with
  case woundHasCommunicationWith = "wound_has_communication_with"
  /// Empty relationship attribute
  case none = ""
}

extension UMLSAdditionalRelationLabel: CaseIterable {}

extension UMLSAdditionalRelationLabel: Sendable {}

extension UMLSAdditionalRelationLabel: Decodable {}

/// UMLS Relationship
public enum UMLSRelationLabel: String {
  /// Allowed qualifier
  case aq = "AQ"
  /// has child relationship in a Metathesaurus source vocabulary
  case chd = "CHD"
  /// Deleted concept
  case del = "DEL"
  /// has parent relationship in a Metathesaurus source vocabulary
  case par = "PAR"
  /// can be qualified by.
  case qb = "QB"
  /// has a broader relationship
  case rb = "RB"
  /// the relationship is similar or "alike". the two concepts are similar or "alike". In the current edition of the Metathesaurus, most relationships with this attribute are mappings provided by a source, named in SAB and SL; hence concepts linked by this relationship may be synonymous, i.e. self-referential: CUI1 = CUI2. In previous releases, some MeSH Supplementary Concept relationships were represented in this way.
  case rl = "RL"
  /// has a narrower relationship
  case rn = "RN"
  /// has relationship other than synonymous, narrower, or broader
  case ro = "RO"
  /// related and possibly synonymous.
  case rq = "RQ"
  /// Related, unspecified
  case ru = "RU"
  /// Concept removed from current subset
  case subx = "SUBX"
  /// source asserted synonymy.
  case sy = "SY"
  /// Not related, no mapping
  case xr = "XR"
  /// Empty relationship
  case none = "NONE"
}

extension UMLSRelationLabel: CaseIterable {}

extension UMLSRelationLabel: Sendable {}

extension UMLSRelationLabel: Decodable {}

/// UMLS Source vocabulary.
public enum UMLSSourceVocabulary: String, CaseIterable, Decodable, Sendable {
  case air = "AIR"
  case cst = "CST"
  case dxp = "DXP"
  case lch = "LCH"
  case mcm = "MCM"
  case snm = "SNM"
  case snmi = "SNMI"
  case who = "WHO"
  case ult = "ULT"
  case icd10 = "ICD10"
  case icpc = "ICPC"
  case qmr = "QMR"
  case rcd = "RCD"
  case ppac = "PPAC"
  case aod = "AOD"
  case bi = "BI"
  case rcdae = "RCDAE"
  case rcdsa = "RCDSA"
  case rcdsy = "RCDSY"
  case icd10ae = "ICD10AE"
  case ccpss = "CCPSS"
  case ram = "RAM"
  case jabl = "JABL"
  case nciseer = "NCISEER"
  case icd10am = "ICD10AM"
  case icd10amae = "ICD10AMAE"
  case ddb = "DDB"
  case hlrel = "HLREL"
  case mthmst = "MTHMST"
  case costar = "COSTAR"
  case pcds = "PCDS"
  case uwda = "UWDA"
  case cpm = "CPM"
  case spn = "SPN"
  case icpc2eeng = "ICPC2EENG"
  case mthicpc2eae = "MTHICPC2EAE"
  case psy = "PSY"
  case mthicpc2icd10ae = "MTHICPC2ICD10AE"
  case icpc2icd10eng = "ICPC2ICD10ENG"
  case ccs = "CCS"
  case hl7vMajor2Minor5 = "HL7V2.5"
  case icpc2p = "ICPC2P"
  case csp = "CSP"
  case aot = "AOT"
  case oms = "OMS"
  case alt = "ALT"
  case icf = "ICF"
  case icfCy = "ICF-CY"
  case icpcfre = "ICPCFRE"
  case chv = "CHV"
  case lchNw = "LCH_NW"
  case icd9cm = "ICD9CM"
  case mthicd9 = "MTHICD9"
  case dsm5 = "DSM-5"
  case nandaI = "NANDA-I"
  case ccc = "CCC"
  case nic = "NIC"
  case mdr = "MDR"
  case noc = "NOC"
  case pdq = "PDQ"
  case fma = "FMA"
  case uspmg = "USPMG"
  case sop = "SOP"
  case cdcrec = "CDCREC"
  case pnds = "PNDS"
  case hgnc = "HGNC"
  case msh = "MSH"
  case neu = "NEU"
  case go = "GO"
  case icd10pcs = "ICD10PCS"
  case icd10cm = "ICD10CM"
  case orphanet = "ORPHANET"
  case cdt = "CDT"
  case cpt = "CPT"
  case hcdt = "HCDT"
  case nucchcpt = "NUCCHCPT"
  case medlineplus = "MEDLINEPLUS"
  case snomedctVet = "SNOMEDCT_VET"
  case hpo = "HPO"
  case nci = "NCI"
  case hl7vMajor3 = "HL7V3.0"
  case umd = "UMD"
  case ncbi = "NCBI"
  case icpcdut = "ICPCDUT"
  case ccsrIcd10cm = "CCSR_ICD10CM"
  case ccsrIcd10pcs = "CCSR_ICD10PCS"
  case hcpcs = "HCPCS"
  case hcpt = "HCPT"
  case omim = "OMIM"
  case icnp = "ICNP"
  case mvx = "MVX"
  case mth = "MTH"
  case lnc = "LNC"
  case mmsl = "MMSL"
  case mmx = "MMX"
  case nddf = "NDDF"
  case rxnorm = "RXNORM"
  case vandf = "VANDF"
  case mthspl = "MTHSPL"
  case gs = "GS"
  case src = "SRC"
  case icpcfin = "ICPCFIN"
  case atc = "ATC"
  case cvx = "CVX"
  case mthcmsfrf = "MTHCMSFRF"
  case drugbank = "DRUGBANK"
  case usp = "USP"
  case snomedctUs = "SNOMEDCT_US"
  case medcin = "MEDCIN"
  case medRt = "MED-RT"
  case cptsp = "CPTSP"
  case dmdicd10 = "DMDICD10"
  case dmdumd = "DMDUMD"
  case icd10dut = "ICD10DUT"
  case icpc2edut = "ICPC2EDUT"
  case icpc2icd10dut = "ICPC2ICD10DUT"
  case icpcbaq = "ICPCBAQ"
  case icpcdan = "ICPCDAN"
  case icpcger = "ICPCGER"
  case icpcheb = "ICPCHEB"
  case icpchun = "ICPCHUN"
  case icpcita = "ICPCITA"
  case icpcnor = "ICPCNOR"
  case icpcpor = "ICPCPOR"
  case icpcspa = "ICPCSPA"
  case icpcswe = "ICPCSWE"
  case kcd5 = "KCD5"
  case lncDeAt = "LNC-DE-AT"
  case lncDeDe = "LNC-DE-DE"
  case lncElGr = "LNC-EL-GR"
  case lncEsAr = "LNC-ES-AR"
  case mshpol = "MSHPOL"
  case lncEsEs = "LNC-ES-ES"
  case lncEsMx = "LNC-ES-MX"
  case lncEtEe = "LNC-ET-EE"
  case lncFrBe = "LNC-FR-BE"
  case lncFrCa = "LNC-FR-CA"
  case lncFrFr = "LNC-FR-FR"
  case lncItIt = "LNC-IT-IT"
  case lncKoKr = "LNC-KO-KR"
  case lncNlNl = "LNC-NL-NL"
  case mshnor = "MSHNOR"
  case lncPlPl = "LNC-PL-PL"
  case lncPtBr = "LNC-PT-BR"
  case lncRuRu = "LNC-RU-RU"
  case lncTrTr = "LNC-TR-TR"
  case lncUkUa = "LNC-UK-UA"
  case lncZhCn = "LNC-ZH-CN"
  case mdrara = "MDRARA"
  case mdrbpo = "MDRBPO"
  case mdrcze = "MDRCZE"
  case mdrdut = "MDRDUT"
  case mdrfre = "MDRFRE"
  case mdrger = "MDRGER"
  case mdrgre = "MDRGRE"
  case mdrhun = "MDRHUN"
  case mdrita = "MDRITA"
  case mdrjpn = "MDRJPN"
  case mdrkor = "MDRKOR"
  case mdrlav = "MDRLAV"
  case mdrpol = "MDRPOL"
  case mdrpor = "MDRPOR"
  case mdrrus = "MDRRUS"
  case mdrspa = "MDRSPA"
  case mdrswe = "MDRSWE"
  case medlineplusSpa = "MEDLINEPLUS_SPA"
  case mshcze = "MSHCZE"
  case mshdut = "MSHDUT"
  case mshfin = "MSHFIN"
  case mshfre = "MSHFRE"
  case mshger = "MSHGER"
  case mshita = "MSHITA"
  case mshjpn = "MSHJPN"
  case mshlav = "MSHLAV"
  case mshpor = "MSHPOR"
  case mshrus = "MSHRUS"
  case mshscr = "MSHSCR"
  case mshspa = "MSHSPA"
  case mshswe = "MSHSWE"
  case mthmstfre = "MTHMSTFRE"
  case mthmstita = "MTHMSTITA"
  case sctspa = "SCTSPA"
  case tkmt = "TKMT"
  case whofre = "WHOFRE"
  case whoger = "WHOGER"
  case whopor = "WHOPOR"
  case whospa = "WHOSPA"

}

#if SemanticType

  public enum UMLSSemanticTypeFlag: String, Decodable, CaseIterable {
    /// Defined flag
    case defined = "D"
    /// Blocked flag
    case blocked = "B"
    /// Defined but Not Inherited by the children of the Arguments.
    case dni = "DNI"
  }

  /// A semantic relation label type.
  public enum UMLSSemanticTypeRelationLabel: String, Decodable, CaseIterable {
    case adjacentTo = "adjacent_to"
    case affects = "affects"
    case analyzes = "analyzes"
    case assessesEffectOf = "assesses_effect_of"
    case associatedWith = "associated_with"
    case branchOf = "branch_of"
    case bringsAbout = "brings_about"
    case carriesOut = "carries_out"
    case causes = "causes"
    case coOccursWith = "co-occurs_with"
    case complicates = "complicates"
    case conceptualPartOf = "conceptual_part_of"
    case conceptuallyRelatedTo = "conceptually_related_to"
    case connectedTo = "connected_to"
    case consistsOf = "consists_of"
    case contains = "contains"
    case degreeOf = "degree_of"
    case derivativeOf = "derivative_of"
    case developmentalFormOf = "developmental_form_of"
    case diagnoses = "diagnoses"
    case disrupts = "disrupts"
    case evaluationOf = "evaluation_of"
    case exhibits = "exhibits"
    case functionallyRelatedTo = "functionally_related_to"
    case indicates = "indicates"
    case ingredientOf = "ingredient_of"
    case interactsWith = "interacts_with"
    case interconnects = "interconnects"
    case isa = "isa"
    case issueIn = "issue_in"
    case locationOf = "location_of"
    case manages = "manages"
    case manifestationOf = "manifestation_of"
    case measurementOf = "measurement_of"
    case measures = "measures"
    case methodOf = "method_of"
    case occursIn = "occurs_in"
    case partOf = "part_of"
    case performs = "performs"
    case physicallyRelatedTo = "physically_related_to"
    case practices = "practices"
    case precedes = "precedes"
    case prevents = "prevents"
    case processOf = "process_of"
    case produces = "produces"
    case propertyOf = "property_of"
    case resultOf = "result_of"
    case spatiallyRelatedTo = "spatially_related_to"
    case surrounds = "surrounds"
    case temporallyRelatedTo = "temporally_related_to"
    case traverses = "traverses"
    case treats = "treats"
    case tributaryOf = "tributary_of"
    case uses = "uses"
  }

#endif

public enum UMLSSemanticType: String, Codable, Sendable, CaseIterable {
  case acquiredAbnormality = "Acquired Abnormality"
  case activity = "Activity"
  case ageGroup = "Age Group"
  case aminoAcidSequence = "Amino Acid Sequence"
  case aminoAcidPeptideOrProtein = "Amino Acid, Peptide, or Protein"
  case amphibian = "Amphibian"
  case anatomicalAbnormality = "Anatomical Abnormality"
  case anatomicalStructure = "Anatomical Structure"
  case animal = "Animal"
  case antibiotic = "Antibiotic"
  case archaeon = "Archaeon"
  case bacterium = "Bacterium"
  case behavior = "Behavior"
  case biologicFunction = "Biologic Function"
  case biologicallyActiveSubstance = "Biologically Active Substance"
  case biomedicalOccupationOrDiscipline = "Biomedical Occupation or Discipline"
  case biomedicalOrDentalMaterial = "Biomedical or Dental Material"
  case bird = "Bird"
  case bodyLocationOrRegion = "Body Location or Region"
  case bodyPartOrganOrOrganComponent = "Body Part, Organ, or Organ Component"
  case bodySpaceOrJunction = "Body Space or Junction"
  case bodySubstance = "Body Substance"
  case bodySystem = "Body System"
  case carbohydrateSequence = "Carbohydrate Sequence"
  case cell = "Cell"
  case cellComponent = "Cell Component"
  case cellFunction = "Cell Function"
  case cellOrMolecularDysfunction = "Cell or Molecular Dysfunction"
  case chemical = "Chemical"
  case chemicalViewedFunctionally = "Chemical Viewed Functionally"
  case chemicalViewedStructurally = "Chemical Viewed Structurally"
  case classification = "Classification"
  case clinicalAttribute = "Clinical Attribute"
  case clinicalDrug = "Clinical Drug"
  case conceptualEntity = "Conceptual Entity"
  case congenitalAbnormality = "Congenital Abnormality"
  case dailyOrRecreationalActivity = "Daily or Recreational Activity"
  case diagnosticProcedure = "Diagnostic Procedure"
  case diseaseOrSyndrome = "Disease or Syndrome"
  case drugDeliveryDevice = "Drug Delivery Device"
  case educationalActivity = "Educational Activity"
  case elementIonOrIsotope = "Element, Ion, or Isotope"
  case embryonicStructure = "Embryonic Structure"
  case entity = "Entity"
  case environmentalEffectOfHumans = "Environmental Effect of Humans"
  case enzyme = "Enzyme"
  case eukaryote = "Eukaryote"
  case event = "Event"
  case experimentalModelOfDisease = "Experimental Model of Disease"
  case familyGroup = "Family Group"
  case finding = "Finding"
  case fish = "Fish"
  case food = "Food"
  case fullyFormedAnatomicalStructure = "Fully Formed Anatomical Structure"
  case functionalConcept = "Functional Concept"
  case fungus = "Fungus"
  case geneOrGenome = "Gene or Genome"
  case geneticFunction = "Genetic Function"
  case geographicArea = "Geographic Area"
  case governmentalOrRegulatoryActivity = "Governmental or Regulatory Activity"
  case group = "Group"
  case groupAttribute = "Group Attribute"
  case hazardousOrPoisonousSubstance = "Hazardous or Poisonous Substance"
  case healthCareActivity = "Health Care Activity"
  case healthCareRelatedOrganization = "Health Care Related Organization"
  case hormone = "Hormone"
  case human = "Human"
  case humanCausedPhenomenonOrProcess = "Human-caused Phenomenon or Process"
  case ideaOrConcept = "Idea or Concept"
  case immunologicFactor = "Immunologic Factor"
  case indicatorReagentOrDiagnosticAid = "Indicator, Reagent, or Diagnostic Aid"
  case individualBehavior = "Individual Behavior"
  case injuryOrPoisoning = "Injury or Poisoning"
  case inorganicChemical = "Inorganic Chemical"
  case intellectualProduct = "Intellectual Product"
  case laboratoryProcedure = "Laboratory Procedure"
  case laboratoryOrTestResult = "Laboratory or Test Result"
  case language = "Language"
  case machineActivity = "Machine Activity"
  case mammal = "Mammal"
  case manufacturedObject = "Manufactured Object"
  case medicalDevice = "Medical Device"
  case mentalProcess = "Mental Process"
  case mentalOrBehavioralDysfunction = "Mental or Behavioral Dysfunction"
  case molecularBiologyResearchTechnique = "Molecular Biology Research Technique"
  case molecularFunction = "Molecular Function"
  case molecularSequence = "Molecular Sequence"
  case naturalPhenomenonOrProcess = "Natural Phenomenon or Process"
  case neoplasticProcess = "Neoplastic Process"
  case nucleicAcidNucleosideOrNucleotide = "Nucleic Acid, Nucleoside, or Nucleotide"
  case nucleotideSequence = "Nucleotide Sequence"
  case occupationOrDiscipline = "Occupation or Discipline"
  case occupationalActivity = "Occupational Activity"
  case organOrTissueFunction = "Organ or Tissue Function"
  case organicChemical = "Organic Chemical"
  case organism = "Organism"
  case organismAttribute = "Organism Attribute"
  case organismFunction = "Organism Function"
  case organization = "Organization"
  case pathologicFunction = "Pathologic Function"
  case patientOrDisabledGroup = "Patient or Disabled Group"
  case pharmacologicSubstance = "Pharmacologic Substance"
  case phenomenonOrProcess = "Phenomenon or Process"
  case physicalObject = "Physical Object"
  case physiologicFunction = "Physiologic Function"
  case plant = "Plant"
  case populationGroup = "Population Group"
  case professionalSociety = "Professional Society"
  case professionalOrOccupationalGroup = "Professional or Occupational Group"
  case qualitativeConcept = "Qualitative Concept"
  case quantitativeConcept = "Quantitative Concept"
  case receptor = "Receptor"
  case regulationOrLaw = "Regulation or Law"
  case reptile = "Reptile"
  case researchActivity = "Research Activity"
  case researchDevice = "Research Device"
  case selfHelpOrReliefOrganization = "Self-help or Relief Organization"
  case signOrSymptom = "Sign or Symptom"
  case socialBehavior = "Social Behavior"
  case spatialConcept = "Spatial Concept"
  case substance = "Substance"
  case temporalConcept = "Temporal Concept"
  case therapeuticOrPreventiveProcedure = "Therapeutic or Preventive Procedure"
  case tissue = "Tissue"
  case vertebrate = "Vertebrate"
  case virus = "Virus"
  case vitamin = "Vitamin"
}
