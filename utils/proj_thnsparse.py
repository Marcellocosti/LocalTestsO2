import ROOT
from ROOT import TFile
import argparse

parser = argparse.ArgumentParser(description="Data output to be projected")

# Add flags/arguments
parser.add_argument("-dpmc", "--dplusmc", help="Project D+ mc reco and gen output", action="store_true")
parser.add_argument("-dpdata", "--dplusdata", help="Project D+ data output", action="store_true")
parser.add_argument("-dsmcreco", "--dsmcreco", help="Project Ds mc reco output", action="store_true")
parser.add_argument("-dsmcgen", "--dsmcgen", help="Project Ds mc gen output", action="store_true")
parser.add_argument("-dsdata", "--dsdata", help="Project Ds data output", action="store_true")
parser.add_argument("-dpflow", "--dplusflow", help="Project D+ flow output", action="store_true")
parser.add_argument("-dpflowep", "--dplusflowep", help="Project D+ flow output", action="store_true")
parser.add_argument("-s", "--suffix", help="Input and output suffix", type=str, default="")
parser.add_argument("-o", "--outdir", help="Input and output suffix", type=str, default="")
parser.add_argument("-sn", "--sparsename", help="Path to sparse to project", type=str, default="")
parser.add_argument("-in", "--inputname", help="Name of file to project", type=str, default="AnalysisResults")
parser.add_argument("-on", "--outputname", help="Name of file to store projections", type=str, default="ThnSparseProj")

# Parse arguments
args = parser.parse_args()

# Perform actions based on the flags
if args.dplusmc:
    sparses = ["Prompt", "FD", "GenPrompt", "GenFD"]
    sparse_name = "hf-task-dplus/hSparseMass"
    print("Projecting D+ mc")

if args.dplusdata:
    sparses = [""]
    sparse_name = "hf-task-dplus/hSparseMass"
    print("Projecting D+ data")

if args.dsmcreco:
    sparses = ["Data", "MC/Ds/Prompt", "MC/Ds/NonPrompt", "MC/Dplus/Prompt", 
               "MC/Dplus/NonPrompt", "MC/Dplus/Bkg", "MC/Lc", "MC/Bkg"]
    sparse_name = "hf-task-ds"
    print("Projecting Ds mc reco")

if args.dsmcgen:
    sparses = ["MC/Ds/Prompt/", "MC/Ds/NonPrompt/", "MC/Dplus/Prompt/", 
                   "MC/Dplus/NonPrompt/", "MC/Bkg/"]
    sparse_name = "hf-task-ds"
    print("Projecting Ds mc gen")

if args.dsdata:
    sparses = ["Data/"]
    sparse_name = "hf-task-ds"
    print("Projecting Ds data")
    
if args.dplusflow:
    sparses = [""]
    sparse_name = "hf-task-flow-charm-hadrons"
    print("Projecting D+ flow")

if args.dplusflowep:
    sparses = ["ep/hSparseEp"]
    sparse_name = "hf-task-flow-charm-hadrons"
    print("Projecting D+ flow ep")

if not any(vars(args).values()):
    print("No actions specified. Use --help for options.")

AN_file = f"{args.outdir}/{args.inputname}" if args.outdir != "" else f"{args.inputname}"
proj_file = f"{args.outdir}/{args.outputname}" if args.outdir != "" else f"{args.outputname}"
print(f"projecting {AN_file} to {proj_file}")

if args.suffix != "":
    test_file = TFile.Open(f'{AN_file}_{args.suffix}.root')
    print(f"Opening {AN_file}_{args.suffix}.root")
    if args.dsmcgen:
        out_file = TFile(f'{proj_file}_{args.suffix}_gen.root', 'recreate')
    else:
        print(f'{proj_file}_{args.suffix}.root')
        out_file = TFile(f'{proj_file}_{args.suffix}.root', 'recreate')
else: 
    test_file = TFile.Open(f'{AN_file}.root')
    suffix = args.suffix + "_gen" if args.dsmcgen else args.suffix
    print(f"Creating {proj_file}{suffix}.root")
    out_file = TFile(f'{proj_file}' + suffix +'.root', 'recreate')

out_file.cd()

for sparse in sparses:
    out_file.mkdir(sparse)
    out_file.cd(sparse)
    
    if args.dplusmc or args.dplusdata or args.dplusflowep:
        print(f"Getting {sparse_name}/{sparse} from {AN_file}_{args.suffix}.root")
        if args.sparsename != "":
            thn_sparse = test_file.Get(args.sparsename)
        else:
            thn_sparse = test_file.Get(f'{sparse_name}{sparse}')
    elif args.dsmcgen:
        if args.sparsename != "":
            thn_sparse = test_file.Get(args.sparsename)
        else:
            thn_sparse = test_file.Get(f'{sparse_name}/{sparse}/hSparseGen')
    elif args.dplusflow:
        if args.sparsename != "":
            thn_sparse = test_file.Get(args.sparsename)
        else:
            thn_sparse = test_file.Get(f'{sparse_name}/hSparseFlowCharm')
    else:
        if args.sparsename != "":
            thn_sparse = test_file.Get(args.sparsename)
        else:
            thn_sparse = test_file.Get(f'{sparse_name}/{sparse}/hSparseMass')
        
    thn_sparse_dimensions = thn_sparse.GetNdimensions()
    print(f"thn_sparse.GetEntries(): {thn_sparse.GetEntries()}")
    for idim in range(thn_sparse_dimensions):
        histo = thn_sparse.Projection(idim)
        print(f"histo.Integral(): {histo.Integral()}")
        histo.SetName(thn_sparse.GetAxis(idim).GetName())
        histo.SetTitle(thn_sparse.GetAxis(idim).GetTitle())
        histo.Write()

out_file.Close()