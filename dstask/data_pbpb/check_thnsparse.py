import ROOT
from ROOT import TFile

sparses = ["Data/"]

test_file = TFile.Open('AnalysisResults.root')
outFile = TFile('ThnSparseProj.root', 'recreate')
outFile.cd()

for sparse in sparses:
    outFile.mkdir(sparse)
    outFile.cd(sparse)
    
    thn_sparse = test_file.Get(f'hf-task-ds/{sparse}/hSparseMass')
    thn_sparse_dimensions = thn_sparse.GetNdimensions()

    for idim in range(thn_sparse_dimensions):
        histo = thn_sparse.Projection(idim)
        histo.SetName(thn_sparse.GetAxis(idim).GetName())
        histo.SetTitle(thn_sparse.GetAxis(idim).GetTitle())
        histo.Write()

outFile.Close()