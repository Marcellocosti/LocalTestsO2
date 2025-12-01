import ROOT
from ROOT import TFile, TTree, TH1F, TLorentzVector, TMath
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import uproot
import awkward as ak
import re

mass_PION = 0.13957  # GeV/c^2
mass_KAON = 0.49367  # GeV/c^2
mass_PROTON = 0.93827  # GeV/c^2

input_file = "/home/mdicosta/LocalTestsO2/DerivedDataCreatorDplus/AO2D.root"

# Print all keys in the root file
with uproot.open(input_file) as f:
    print("Keys in the root file:")
    def print_keys(dir_obj, prefix=""):
        for key, obj in dir_obj.items():
            fullpath = f"{prefix}{key}"
            print(fullpath)
            if isinstance(obj, uproot.reading.ReadOnlyDirectory):
                print_keys(obj, prefix=f"{fullpath}/")
    print_keys(f)

def calc_mass_3p(px1, px2, px3, py1, py2, py3, pz1, pz2, pz3, m1, m2, m3):
    e1 = np.sqrt(m1*m1 + px1*px1 + py1*py1 + pz1*pz1)
    e2 = np.sqrt(m2*m2 + px2*px2 + py2*py2 + pz2*pz2)
    e3 = np.sqrt(m3*m3 + px3*px3 + py3*py3 + pz3*pz3)

    E = e1 + e2 + e3
    P = np.sqrt((px1 + px2 + px3)**2 + (py1 + py2 + py3)**2 + (pz1 + pz2 + pz3)**2)

    return np.sqrt(E*E - P*P)

def load_trees_recursively(file, patterns):
    """
    patterns: list of regex patterns, e.g. ["O2hfdpdaug.*", "O2hfdpml.*"]
    returns: dict {tree_name: awkward array}
    """
    arrays = {}
    print(f"Loading trees matching patterns: {patterns}")

    def walk(dir_obj, prefix=""):
        # print("\n\n")
        # print(f"Calling walk on prefix: {prefix}")
        for key, obj in dir_obj.items():
            # print(f"prefix key: {prefix}{key}")
            # print(f"obj: {obj}")
            fullpath = f"{prefix}{key}"

            # uproot identifies trees as TTree-like objects
            if isinstance(obj, uproot.behaviors.TTree.TTree):
                for pat in patterns:
                    # print(f"Trying to match pattern: {pat} with key: {key}")
                    if pat in key:

                        # Extend arrays dict
                        if pat in arrays:
                            print(f"Extending array for key: {fullpath}")
                            # print(f"Warning: key {key.split(';')[0]} already in arrays, skipping...")
                            arrays[pat] = ak.concatenate([arrays[pat], obj.arrays(library="ak")])
                        else:
                            print(f"Loading array for key: {fullpath}")
                            arrays[pat] = obj.arrays(library="ak")
                        break

            # If it is a directory → recurse
            if isinstance(obj, uproot.reading.ReadOnlyDirectory):
                if not ";1" in key:  # Skip versioned keys
                    walk(obj, prefix=f"{fullpath}/")

    walk(file)
    return arrays

patterns = ["O2hfdpdaug", "O2hfdpml"]

with uproot.open(input_file) as f:
    arrays = load_trees_recursively(f, patterns)

print(f"arrays keys: {list(arrays.keys())}")
print(f"arrays: {arrays}")

full_array = ak.zip(
    {
        field: arrays[tree][field]
        for tree in arrays
        for field in arrays[tree].fields
    },
    depth_limit=1
)

print(f"full_array: {full_array}")

# Extend array with mass hypotheses
full_array = ak.with_field(
    full_array,
    calc_mass_3p(full_array["fPxProng0"], full_array["fPxProng1"], full_array["fPxProng2"],
                 full_array["fPyProng0"], full_array["fPyProng1"], full_array["fPyProng2"],
                 full_array["fPzProng0"], full_array["fPzProng1"], full_array["fPzProng2"],
                 mass_PION, mass_KAON, mass_PION),
    "fMassPiKPi"
)

# Columns to plot
columns_to_plot = ["fPt", "fChi2PCA", "fMassPiKPi"]
for column in columns_to_plot:
    plt.figure()
    if column == "fMassPiKPi":
        plt.hist(ak.to_numpy(full_array[column]), bins=35, range=(1.725, 1.76), histtype='step', label=column)
    else:
        plt.hist(ak.to_numpy(full_array[column]), bins=100, histtype='step', label=column)
    plt.xlabel(column)
    plt.ylabel("Counts")
    plt.title(f"Distribution of {column}")
    plt.legend()
    plt.grid()
    # plt.yscale('log')
    plt.show()

    # Save to png
    plt.savefig(f"{column}_distribution.png")
