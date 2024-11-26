o2-analysis-pid-tof-full -b --configuration json://cfg.json |\
o2-analysis-pid-tof-base -b --configuration json://cfg.json |\
o2-analysis-hf-pid-creator -b --configuration json://cfg.json |\
o2-analysis-pid-tpc -b --configuration json://cfg.json |\
o2-analysis-ft0-corrected-table -b --configuration json://cfg.json |\
o2-analysis-timestamp -b --configuration json://cfg.json |\
# o2-analysis-qvector-table -b --configuration json://cfg.json |\
# o2-analysis-hf-task-flow-charm-hadrons -b --configuration json://cfg.json |\
o2-analysis-hf-track-index-skim-creator -b --configuration json://cfg.json |\
o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi -b --configuration json://cfg.json |\
# o2-analysis-hf-candidate-selector-d0 -b --configuration json://cfg.json |\
o2-analysis-event-selection -b --configuration json://cfg.json |\
o2-analysis-multiplicity-table -b --configuration json://cfg.json |\
o2-analysis-track-to-collision-associator -b --configuration json://cfg.json |\
o2-analysis-pid-tpc-base -b --configuration json://cfg.json |\
o2-analysis-track-propagation -b --configuration json://cfg.json |\
o2-analysis-trackselection -b --configuration json://cfg.json |\
o2-analysis-centrality-table -b --configuration json://cfg.json |\
# o2-analysis-hf-task-dplus -b --configuration json://cfg.json |\
o2-analysis-mccollision-converter -b --configuration json://cfg.json |\
# o2-analysis-hf-candidate-creator-2prong -b --configuration json://cfg.json --aod-file /data/spolitan/flow/localtest/AO2D_LHC23zzh_544116_apass4_0140_original.root
o2-analysis-hf-candidate-creator-3prong -b --configuration json://cfg.json --aod-file /data/spolitan/flow/localtest/AO2D_LHC23zzh_544116_apass4_0140_original.root

# o2-analysis-pid-tof-full -b --configuration json://configfromdpl.json |\
# o2-analysis-pid-tof-base -b --configuration json://configfromdpl.json |\
# o2-analysis-hf-pid-creator -b --configuration json://configfromdpl.json |\
# o2-analysis-pid-tpc -b --configuration json://configfromdpl.json |\
# o2-analysis-ft0-corrected-table -b --configuration json://configfromdpl.json |\
# o2-analysis-timestamp -b --configuration json://configfromdpl.json |\
# o2-analysis-qvector-table -b --configuration json://configfromdpl.json |\
# o2-analysis-hf-task-flow-charm-hadrons -b --configuration json://configfromdpl.json |\
# o2-analysis-hf-track-index-skim-creator -b --configuration json://configfromdpl.json |\
# #o2-analysis-hf-candidate-selector-dplus-to-pi-k-pi -b --configuration json://configfromdpl.json |\
# o2-analysis-hf-candidate-selector-d0 -b --configuration json://configfromdpl.json |\
# o2-analysis-event-selection -b --configuration json://configfromdpl.json |\
# o2-analysis-multiplicity-table -b --configuration json://configfromdpl.json |\
# o2-analysis-track-to-collision-associator -b --configuration json://configfromdpl.json |\
# o2-analysis-pid-tpc-base -b --configuration json://configfromdpl.json |\
# o2-analysis-track-propagation -b --configuration json://configfromdpl.json |\
# o2-analysis-trackselection -b --configuration json://configfromdpl.json |\
# o2-analysis-centrality-table -b --configuration json://configfromdpl.json |\
# o2-analysis-hf-candidate-creator-2prong -b --configuration json://configfromdpl.json --aod-file /data/spolitan/flow/localtest/AO2D_LHC23zzh_544116_apass4_0140_original.root
# #o2-analysis-hf-candidate-creator-3prong -b --configuration json://configfromdpl.json --aod-file /data/spolitan/flow/localtest/AO2D_LHC23zzh_544116_apass4_0140_original.root