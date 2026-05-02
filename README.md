# REFINE-HFpEF

## Overview

This repository contains the SQL and Stata code used for cohort identification, data extraction, data preparation, and statistical analysis for **REFINE-HFpEF**, a nationwide study conducted within the U.S. Department of Veterans Affairs (VA) health system.

REFINE-HFpEF is part of a broader project evaluating the effectiveness of sodium-glucose cotransporter 2 inhibitors (**SGLT2 inhibitors**, or **SGLT2i**) among patients with heart failure with preserved ejection fraction (**HFpEF**). This study specifically evaluates the association between SGLT2i use and two clinical outcomes: heart failure hospitalization and all-cause mortality.

Two separate cohort extractions and analyses were conducted:

1. **Original Analysis / On-Treatment Analysis** 
This analysis required three consecutive prescription refills for both SGLT2i users and active comparator users as a criterion for cohort entry. The purpose of this approach was to evaluate the on-treatment effectiveness of SGLT2i in this population.

2. **ITT-like Analysis** 
This analysis removed the requirement for three consecutive prescription refills. This approach was intended to approximate an intention-to-treat-like analytic framework.

## Repository contents

This repository includes:

- SQL code for cohort identification and extraction of study variables from the VA database
- One SQL script for the original “On-Treatment” cohort extraction
- One SQL script for the ITT-like cohort extraction
- STATA do-files for data cleaning, merging, variable construction, cohort assembly, and statistical analysis
- Sequentially numbered STATA do-files to indicate the order of the analytic workflow

## File organization and naming convention

The repository contains two parallel Stata workflows, each stored in a separate folder:

- `Original Analysis`: contains the on-treatment cohort and corresponding analysis
- `ITT`: contains the ITT-like cohort and corresponding analysis

Throughout the files, **SGLT2** refers to sodium-glucose cotransporter 2 inhibitors. The control group consists of a combination of dipeptidyl peptidase-4 inhibitors and sulfonylureas. In the file names and code, this combined control group is usually referred to as **dpp4**.

## Use and interpretation

These scripts were created within the VA data environment, including the VA Informatics and Computing Infrastructure (VINCI), and are intended to document the analytic methods used in the associated manuscript.

This repository does **not** contain patient-level data.

## Reproducibility statement

The purpose of this repository is to enhance methodological transparency by providing the code used for data extraction and statistical analysis.

Reproduction of the full workflow requires appropriate authorization and access to VA data sources within the VA VINCI environment. The code is provided to support review of the analytic approach and to clarify how the study cohorts, exposure groups, covariates, outcomes, and statistical analyses were implemented.

## Contact

Please contact the repository owner with any questions regarding the code or workflow:

Irfan Helmy, MD | Varun Sundaram, MD, PhD, MSc

ixh119@case.edu | vxs173@case.edu

Louis Stokes Cleveland Veteran Affairs Medical Center

Case Western Reserve University School of Medicine
