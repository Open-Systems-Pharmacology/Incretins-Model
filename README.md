# Incretins-Model
A Physiologically‐Based Quantitative Systems Pharmacology Model of the Incretin Hormones GLP‐1 and GIP and the DPP4 Inhibitor Sitagliptin.

![Physiology of glucagon‐like peptide‐1 (GLP‐1) and glucose‐dependent insulinotropic polypeptide (GIP) pharmacokinetic as modeled.](..\Figures\Figure_1.png)

_Physiology of glucagon-like peptide-1 (GLP-1) and glucose-dependent insulinotropic polypeptide (GIP) pharmacokinetic as modeled. Figure taken from [1](#references), copyright by CPT:PSP._

Within this repository, we distribute a physiologically-based mechanistic model of the incretin hormones GLP-1 and GIP coupled with a PBPK/PD model of a DPP4 inhibitor sitagliptin. The model captures glucose-induced secretion of the hormones and their degradation by the enzymes DPP4 and NEP (MME).

## Repository files
The model is provided as a MoBi project **PB_QSP_Incretins_model.mbp3**. The model was created with the Open Systems Pharmacology Suite (OSPS) version 8. The project includes various simulations that are described in [1](#references).

The folder **RScript** contains R-script files used to generate figures of the original publication [[1](#references)]. To execute them, the [OSPS toolbox for R](https://github.com/Open-Systems-Pharmacology/R-Toolbox/releases) version 8 is required. The archives **Models_XML.zip** and **ExpData.zip** include the model files and experimental data extracted from literature, respectively, required for executing the scripts. If you want to run the scripts, adjust the paths to the respective folders in the script files.

## Version information
The physiology is based on the PBPK model implemented in PK-Sim version 8.
The MoBi project was created in version 8.

## Code of conduct
Everyone interacting in the Open Systems Pharmacology community (codebases, issue trackers, chat rooms, mailing lists etc...) is expected to follow the Open Systems Pharmacology [code of conduct](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODE_OF_CONDUCT.md#contributor-covenant-code-of-conduct).

## Contribution
We encourage contribution to the Open Systems Pharmacology community. Before getting started please read the [contribution guidelines](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CONTRIBUTING.md#ways-to-contribute). If you are contributing code, please be familiar with the [coding standard](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODING_STANDARDS.md#visual-studio-settings).

## License
The model code is distributed under the [GPLv2 License](https://github.com/Open-Systems-Pharmacology/Suite/blob/develop/LICENSE).

## References

[1] Balazki, P., Schaller, S., Eissing, T. & Lehr, T. A Physiologically‐Based Quantitative Systems Pharmacology Model of the Incretin Hormones GLP‐1 and GIP and the DPP4 Inhibitor Sitagliptin. *CPT Pharmacometrics Syst. Pharmacol.* psp4.12520 (2020).doi:[10.1002/psp4.12520](https://doi.org/10.1002/psp4.12520)