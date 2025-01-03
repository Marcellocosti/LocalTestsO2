import ROOT
from ROOT import TFile

test_file = TFile.Open('AnalysisResults.root')

# sparses = ["Data/", "MC/Ds/Prompt/", "MC/Ds/NonPrompt/", "MC/Dplus/Prompt/", 
#            "MC/Dplus/NonPrompt/", "MC/Dplus/Bkg/", "MC/Lc/", "MC/Bkg/"]

sparses = ["Data/", "MC/Ds/Prompt/", "MC/Ds/NonPrompt/", "MC/Dplus/Prompt/", 
           "MC/Dplus/NonPrompt/", "MC/Dplus/Bkg/", "MC/Lc/"]

out_file = TFile('ThnSparseProj.root', 'recreate')
out_file.cd()
for sparse in sparses:
    print(sparse)
    out_file.mkdir(sparse)
    out_file.cd(sparse)

    thn_sparse = test_file.Get(f'hf-task-ds/{sparse}hSparseMass')
    thn_sparse_dimensions = thn_sparse.GetNdimensions()

    for idim in range(thn_sparse_dimensions):
        histo = thn_sparse.Projection(idim)
        histo.SetName(thn_sparse.GetAxis(idim).GetName())
        histo.SetTitle(thn_sparse.GetAxis(idim).GetTitle())
        histo.Write()

out_file.Close()

# sparses_gen = ["MC/Ds/Prompt/", "MC/Ds/NonPrompt/", "MC/Dplus/Prompt/", 
#                "MC/Dplus/NonPrompt/", "MC/Bkg/"]

# out_file_gen = TFile('ThnSparseProjGen.root', 'recreate')
# out_file_gen.cd()
# for sparse in sparses_gen:
#     out_file_gen.mkdir(sparse)
#     out_file_gen.cd(sparse)

#     # thn_sparse = test_file.Get(f'hf-task-ds/{sparse}hSparseMass')
#     thn_sparse = test_file.Get(f'hf-task-ds/{sparse}hSparseGen')
#     thn_sparse_dimensions = thn_sparse.GetNdimensions()

#     for idim in range(thn_sparse_dimensions):
#         histo = thn_sparse.Projection(idim)
#         histo.SetName(thn_sparse.GetAxis(idim).GetName())
#         histo.SetTitle(thn_sparse.GetAxis(idim).GetTitle())
#         histo.Write()
        

# out_file_gen.Close()