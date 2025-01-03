import ROOT
from ROOT import TFile

test_file = TFile.Open('AnalysisResults.root')
thn_sparse = test_file.Get('hf-task-dplus/hSparseMass')
thn_sparse_dimensions = thn_sparse.GetNdimensions()

outFile = TFile('ThnSparseProj.root', 'recreate')
outFile.cd()
for idim in range(thn_sparse_dimensions):
    histo = thn_sparse.Projection(idim)
    histo.SetName(thn_sparse.GetAxis(idim).GetName())
    histo.SetTitle(thn_sparse.GetAxis(idim).GetTitle())
    histo.Write()
outFile.Close()