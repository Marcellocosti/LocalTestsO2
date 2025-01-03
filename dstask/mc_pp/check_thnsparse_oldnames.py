import ROOT
from ROOT import TFile

test_file = TFile.Open('AnalysisResults_aftercommit.root')

sparses = ["MC/Ds/Prompt/", "MC/Ds/NonPrompt/", "MC/Dplus/Prompt/", 
           "MC/Dplus/NonPrompt/", "MC/Dplus/Bkg/", "MC/Lc/"]

out_file = TFile('ThnSparseProj_old.root', 'recreate')
out_file.cd()
for sparse in sparses:
    out_file.mkdir(sparse)
    out_file.cd(sparse)

    thn_sparse = test_file.Get(f'hf-task-ds/{sparse}hPtYNPvContribGen')
    thn_sparse_dimensions = thn_sparse.GetNdimensions()

    for idim in range(thn_sparse_dimensions):
        histo = thn_sparse.Projection(idim)
        histo.SetName(thn_sparse.GetAxis(idim).GetName())
        histo.SetTitle(thn_sparse.GetAxis(idim).GetTitle())
        histo.Write()

out_file.Close()