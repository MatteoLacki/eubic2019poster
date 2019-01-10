Retention Time Alignment

Modern proteomics offers a variety of methods aimed at characterisation of the molecular composition of bioanalytes. 
The ultimate goal of these methods is to achieve highly reproducible measurements.
For this reason, numerous experimental set-ups, such as LC/MS or LC/IMS/MS, have been devised. 
The initial step in most of current experiments involves the measurement of retention times of the molecules using liquid chromatography, LC.
In LC, the bioanalyte elutes over time, enhancing detection rates and sensibility of the subsequent methods.
However, the elution profiles can significantly vary even over technical replicates of the same sample.
This limits capabilities of algorithms used for peptide sequencing.
To overcome these issues, several algorithmic approaches have been devised, such as the Match Between Runs algorithm in MaxQuant, or the alignment applied in the IsoQuant software.
Both approaches rely on the combined use of the technical replicates of the experiment.
Signals confidently identified in a series of replicates are used to sequence unidentified signals in the remaining runs.
During this process, the algorithms readjust the retention times, to further help the identification process.

Our current work aims at significantly speeding up the process of alignment through direct use of the information gathered in the sequenced signals.
The approach can be used whenever the space of observed retention times is sufficienly probed by the identified peptides.
With the continuous progress in the methods of analytical chemistry, especially in LC/IMS/MS, the potential limitations of this approach are averted.
The direct use of sequenced signal turns the problem of retention time alignment to a problem akin to nonlinear regression.
We solve the problem by application of robust beta splines.
The proposed algorithm is quick (an alignment of one signal lasts microseconds), thus offering the possibility to perform automated optimization of the method's parameters, through the use of stratified cross-validation.
This liberates the user from specifying the parameters, without compromizing the overall robustness of the method.

