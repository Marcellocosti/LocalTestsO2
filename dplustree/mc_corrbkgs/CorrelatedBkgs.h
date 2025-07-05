// Copyright 2019-2020 CERN and copyright holders of ALICE O2.
// See https://alice-o2.web.cern.ch/copyright for details of the copyright holders.
// All rights not expressly granted are reserved.
//
// This software is distributed under the terms of the GNU General Public
// License v3 (GPL Version 3), copied verbatim in the file "COPYING".
//
// In applying this license CERN does not waive the privileges and immunities
// granted to it by virtue of its status as an Intergovernmental Organization
// or submit itself to any jurisdiction.

/// \file CorrelatedBkgTagger.h
/// \brief Definitions of channels for correlated bkgs
/// \author Marcello Di Costanzo <marcello.di.costanzo@cern.ch>, Polytechnic of Turin and INFN

#include <unordered_map>
#include <array>
#include <variant>

#include "/home/mdicosta/alice/O2Physics/Common/Core/RecoDecay.h"

#ifndef PWGHF_CORE_CORRELATEDBKGTAGGER_H_
#define PWGHF_CORE_CORRELATEDBKGTAGGER_H_

using namespace o2::constants::physics;

namespace o2::hf_corrbkg
{

    enum FinalStatesDMesons {
        KKPi = 1,
        KKPiPi0,
        KPiPi,
        KPiPiPi0,
        PiPiPi,
        PiPiPiPi0,
        ProtonPiPi,
        ProtonKPi,
        NFinalStates
    };

    // D± → K± K∓ π±
    namespace DPlus {
      enum DecayChannelResoDplus {
        K0starK = 1,
        K_1430K,
        PhiPi,
        RhoPi,
        f2_1270Pi,
      };

      std::unordered_map<DecayChannelResoDplus, std::array<int, 2> > resoStatesDPlus = 
      {
        {DecayChannelResoDplus::K0starK, std::array<int, 2>{-kK0Star892, -kKPlus}},
        {DecayChannelResoDplus::K_1430K, std::array<int, 2>{-10321, -kKPlus}},
        {DecayChannelResoDplus::PhiPi, std::array<int, 2>{+kPhi, +kPiPlus}},
        {DecayChannelResoDplus::RhoPi, std::array<int, 2>{+213, +kPiPlus}},
        {DecayChannelResoDplus::f2_1270Pi, std::array<int, 2>{225, +kPiPlus}},
      };
    }
    
    // Ds± → K± K∓ π±
    namespace DS {
      enum DecayChannelResoDs {
          PhiPi = 1,
          K0starK,
          PhiRho,
          f2_1270Pi,
          K0starPi,
          RhoK,
          EtaPi,
      };
        
      std::unordered_map<DecayChannelResoDs, std::array<int, 2> > resoStatesDs = 
      {
        {DecayChannelResoDs::PhiPi, std::array<int, 2>{+kPhi, +kPiPlus}},
        {DecayChannelResoDs::K0starK, std::array<int, 2>{-kK0Star892, -kKPlus}},
        {DecayChannelResoDs::PhiRho, std::array<int, 2>{-kPhi, -113}},
        {DecayChannelResoDs::f2_1270Pi, std::array<int, 2>{225, +kPiPlus}},
        {DecayChannelResoDs::K0starPi, std::array<int, 2>{-kK0Star892, -kPiPlus}},
        {DecayChannelResoDs::RhoK, std::array<int, 2>{-113, -kKPlus}},
        {DecayChannelResoDs::EtaPi, std::array<int, 2>{-221, -kPiPlus}},
      };
    }

    // Dstar → K± K∓ π±
    namespace DStar {
      enum DecayChannelResoDStar {
          PhiPi = 1,
          K0starK,
      };

      std::unordered_map<DecayChannelResoDStar, std::array<int, 2> > resoStatesDStar = 
      {
          {DecayChannelResoDStar::PhiPi, std::array<int, 2>{+kPhi, +kPiPlus}},
          {DecayChannelResoDStar::K0starK, std::array<int, 2>{-kK0Star892, -kKPlus}},
      };
    }

    // Lc → p K∓ π±
    namespace LambdaC {
      enum DecayChannelResoLambdaC {
        K0starP = 1,
        DeltaK,
        Lambda1520Pi,
        ProtonPhi,
      }; 

      std::unordered_map<DecayChannelResoLambdaC, std::array<int, 2> > resoStatesLambdaC = 
      {
        {DecayChannelResoLambdaC::K0starP, std::array<int, 2>{-kK0Star892, -kProton}},
        {DecayChannelResoLambdaC::DeltaK, std::array<int, 2>{+2224, -kKPlus}},
        {DecayChannelResoLambdaC::Lambda1520Pi, std::array<int, 2>{+102134, -kPiPlus}},
        {DecayChannelResoLambdaC::ProtonPhi, std::array<int, 2>{+kProton, -kPhi}},
      };
    }
    
    // Xic → p K∓ π±
    namespace XiC {
      enum DecayChannelResoXiC {
        K0starP = 1,
        ProtonPhi,
        // SigmaPiPi,
      };
      
      std::unordered_map<DecayChannelResoXiC, std::array<int, 2> > resoStatesXiC = 
      {
        {DecayChannelResoXiC::K0starP, std::array<int, 2>{-kK0Star892, -kProton}},
        {DecayChannelResoXiC::ProtonPhi, std::array<int, 2>{+kProton, -kPhi}},
        // {DecayChannelResoXiC::SigmaPiPi, std::array<int, 2>{+kProton, -kPhi}},
      };
    }

    bool checkResonantDecay(std::vector<int> arrDaughIndex, std::array<int, 2> arrPDGResonant) {
      for (int iArrDaugh : arrDaughIndex) {
        bool findDaug = false;
        for (int i = 0; i < 2; ++i) {
          std::cout << "Checking daughter PDG: " << iArrDaugh << " against expected PDG: " << arrPDGResonant[i] << std::endl;
          if (std::abs(iArrDaugh) == arrPDGResonant[i]) {
            findDaug = true;
          }
        }
        if (!findDaug) {
          return false; // If any daughter does not match, return false
        }
      }
      return true;
    }

    /// Check if the decay is resonant
    /// \tparam arrDaughIndex index of the particle daughters at resonance level
    /// \tparam arrPDGResonant PDG code of the resonant decay
    /// \return true if the decay is resonant
    void flagResonantDecay(int motherPdg, int8_t* channel, std::vector<int> arrDaughIndex) {
      switch (motherPdg) {
        case Pdg::kDPlus:
          std::cout << "Checking for resonant decay channel for D+" << std::endl;
          for (const auto resoDPlus : DPlus::resoStatesDPlus) {
            if (checkResonantDecay(arrDaughIndex, resoDPlus.second)) {
              std::cout << "Resonant decay channel found: " << resoDPlus.first << std::endl;
              *channel = (1 << resoDPlus.first);
              break;
            }
          }
          break;
        case Pdg::kDS:
          std::cout << "Checking for resonant decay channel for D_s+" << std::endl;
          for (const auto resoDs : DS::resoStatesDs) {
            if (checkResonantDecay(arrDaughIndex, resoDs.second)) {
              std::cout << "Resonant decay channel found: " << resoDs.first << std::endl;
              *channel = (1 << resoDs.first);
              break;
            }
          }
          break;
        case Pdg::kDStar:
          std::cout << "Checking for resonant decay channel for D*" << std::endl;
          for (const auto resoDstar : DStar::resoStatesDStar) {
            if (checkResonantDecay(arrDaughIndex, resoDstar.second)) {
              std::cout << "Resonant decay channel found: " << resoDstar.first << std::endl;
              *channel = (1 << resoDstar.first);
              break;
            }
          }
          break;
        case Pdg::kLambdaCPlus:
          std::cout << "Checking for resonant decay channel for Lambda_c+" << std::endl;
          for (const auto resoLambdaC : LambdaC::resoStatesLambdaC) {
            if (checkResonantDecay(arrDaughIndex, resoLambdaC.second)) {
              std::cout << "Resonant decay channel found: " << resoLambdaC.first << std::endl;
              *channel = (1 << resoLambdaC.first);
              break;
            }
          }
          break;
        case Pdg::kXiCPlus:
          std::cout << "Checking for resonant decay channel for Xi_c+" << std::endl;
          for (const auto resoXiC : XiC::resoStatesXiC) {
            if (checkResonantDecay(arrDaughIndex, resoXiC.second)) {
              std::cout << "Resonant decay channel found: " << resoXiC.first << std::endl;
              *channel = (1 << resoXiC.first);
              break;
            }
          }
          break;
      }
    }

    /// Checks whether the reconstructed decay candidate is the expected decay.
    /// \tparam acceptFlavourOscillation  switch to accept flavour oscillastion (i.e. B0 -> B0bar -> D+pi-)
    /// \tparam checkProcess  switch to accept only decay daughters by checking the production process of MC particles
    /// \tparam acceptIncompleteReco  switch to accept candidates with only part of the daughters reconstructed
    /// \tparam acceptTrackDecay  switch to accept candidates with daughter tracks of pions and kaons which decayed
    /// \tparam acceptTrackIntWithMaterial switch to accept candidates with final (i.e. p, K, pi) daughter tracks interacting with material
    /// \param particlesMC  table with MC particles
    /// \param arrDaughters  array of candidate daughters
    /// \param pdgMother  expected mother PDG code
    /// \param arrPdgDaughters  array of expected daughter PDG codes
    /// \param acceptAntiParticles  switch to accept the antiparticle version of the expected decay
    /// \param sign  antiparticle indicator of the found mother w.r.t. pdgMother; 1 if particle, -1 if antiparticle, 0 if mother not found
    /// \param depthMax  maximum decay tree level to check; Daughters up to this level will be considered. If -1, all levels are considered.
    /// \param nPiToMu  number of pion prongs decayed to a muon
    /// \param nKaToPi  number of kaon prongs decayed to a pion
    /// \param nInteractionsWithMaterial  number of daughter particles that interacted with material
    /// \return index of the mother particle if the mother and daughters are correct, -1 otherwise
    template <bool acceptFlavourOscillation = false, bool checkProcess = false, bool acceptIncompleteReco = false, bool acceptTrackDecay = false, bool acceptTrackIntWithMaterial = false, std::size_t NDaug, std::size_t NFinParts, typename T, typename U>
    std::vector<int> getMatchedMCRecDaugIdxs(const T& particlesMC,
                                            const std::array<U, NDaug>& arrDaughters,
                                            std::vector<int> pdgMothers,
                                            std::array<int, NFinParts> pdgFinParts,
                                            int &indexRec,
                                            int &matchedMotherId,
                                            bool acceptAntiParticles = false,
                                            int8_t* sign = nullptr,
                                            int depthMax = 1,
                                            int8_t* nPiToMu = nullptr,
                                            int8_t* nKaToPi = nullptr,
                                            int8_t* nInteractionsWithMaterial = nullptr)
    {
        // Printf("MC Rec: Expected mother PDG: %d", pdgMother);
        int8_t coefFlavourOscillation = 1;         // 1 if no B0(s) flavour oscillation occured, -1 else
        int8_t sgn = 0;                            // 1 if the expected mother is particle, -1 if antiparticle (w.r.t. pdgMother)
        int8_t nPiToMuLocal = 0;                   // number of pion prongs decayed to a muon
        int8_t nKaToPiLocal = 0;                   // number of kaon prongs decayed to a pion
        int8_t nInteractionsWithMaterialLocal = 0; // number of interactions with material
        int indexMother = -1;                      // index of the mother particle
        std::vector<int> arrAllDaughtersIndex;     // vector of indices of all daughters of the mother of the first provided daughter
        std::array<int, NDaug> arrDaughtersIndex;      // array of indices of provided daughters
        if (sign) {
          *sign = sgn;
        }
        if constexpr (acceptFlavourOscillation) {
          // Loop over decay candidate prongs to spot possible oscillation decay product
          for (std::size_t iProng = 0; iProng < NDaug; ++iProng) {
            if (!arrDaughters[iProng].has_mcParticle()) {
              return {};
            }
            auto particleI = arrDaughters[iProng].mcParticle();      // ith daughter particle
            if (std::abs(particleI.getGenStatusCode()) == 92) {      // oscillation decay product spotted
              coefFlavourOscillation = -1;                           // select the sign of the mother after oscillation (and not before)
              break;
            }
          }
        }
        // Loop over decay candidate prongs
        for (std::size_t iProng = 0; iProng < NDaug; ++iProng) {
          std::cout << "    [getMatchedMCRecDaugIdxs] Prong " << iProng << std::endl;
          if (!arrDaughters[iProng].has_mcParticle()) {
            return {};
          }
          auto particleI = arrDaughters[iProng].mcParticle(); // ith daughter particle
          if constexpr (acceptTrackDecay) {
            // Replace the MC particle associated with the prong by its mother for π → μ and K → π.
            auto motherI = particleI.template mothers_first_as<T>();
            auto pdgI = std::abs(particleI.pdgCode());
            auto pdgMotherI = std::abs(motherI.pdgCode());
            if (pdgI == kMuonMinus && pdgMotherI == kPiPlus) {
              // π → μ
              nPiToMuLocal++;
              particleI = motherI;
            } else if (pdgI == kPiPlus && pdgMotherI == kKPlus) {
              // K → π
              nKaToPiLocal++;
              particleI = motherI;
            }
          }
          if constexpr (acceptTrackIntWithMaterial) {
            // Replace the MC particle associated with the prong by its mother for part → part due to material interactions.
            // It keeps looking at the mother iteratively, until it finds a particle from decay or primary
            auto process = particleI.getProcess();
            auto pdgI = std::abs(particleI.pdgCode());
            auto pdgMotherI = std::abs(particleI.pdgCode());
            while (process != TMCProcess::kPDecay && process != TMCProcess::kPPrimary && pdgI == pdgMotherI) {
              if (!particleI.has_mothers()) {
                break;
              }
              auto motherI = particleI.template mothers_first_as<T>();
              pdgI = std::abs(particleI.pdgCode());
              pdgMotherI = std::abs(motherI.pdgCode());
              if (pdgI == pdgMotherI) {
                particleI = motherI;
                process = particleI.getProcess();
                if (process == TMCProcess::kPDecay || process == TMCProcess::kPPrimary) { // we found the original daughter that interacted with material
                  nInteractionsWithMaterialLocal++;
                }
              }
            }
          }
          arrDaughtersIndex[iProng] = particleI.globalIndex();
          std::cout << "    [getMatchedMCRecDaugIdxs] Prong " << iProng << " index: " << arrDaughtersIndex[iProng] << std::endl;
          // Get the list of daughter indices from the mother of the first prong.
          if (iProng == 0) {
            // Get the mother index and its sign.
            // PDG code of the first daughter's mother determines whether the expected mother is a particle or antiparticle.
            for (int iPdgMother = 0; iPdgMother < static_cast<int>(pdgMothers.size()); ++iPdgMother) {
              std::cout << "MC Rec: Checking mother PDG: " << iPdgMother << std::endl;
              indexMother = RecoDecay::getMother(particlesMC, particleI, iPdgMother, acceptAntiParticles, &sgn, depthMax);
              // Check whether mother was found.
              if (indexMother <= -1) {
                std::cout << "MC Rec: PDG not matched" << std::endl;
                continue;
              }
              std::cout << "MC Rec: Good mother: " << indexMother << std::endl;
              indexRec = indexMother; // Store the index of the mother particle.
              matchedMotherId = iPdgMother; // Store the PDG code of the mother particle.
              arrAllDaughtersIndex.push_back(indexMother); // Add the mother index to the list of expected daughters.
              auto particleMother = particlesMC.rawIteratorAt(indexMother - particlesMC.offset());
              // Check the daughter indices.
              if (!particleMother.has_daughters()) {
                std::cout << "MC Rec: Rejected: bad daughter index range: " << particleMother.daughtersIds().front() << "-" << particleMother.daughtersIds().back() << std::endl;
                return {};
              }
              // Check that the number of direct daughters is not larger than the number of expected final daughters.
              if constexpr (!acceptIncompleteReco && !checkProcess) {
                if (particleMother.daughtersIds().back() - particleMother.daughtersIds().front() + 1 > static_cast<int>(NDaug)) {
                  std::cout << "MC Rec: Rejected: too many direct daughters: " << particleMother.daughtersIds().back() - particleMother.daughtersIds().front() + 1
                      << " (expected " << NDaug << " final)" << std::endl;
                  // Printf("MC Rec: Rejected: too many direct daughters: %d (expected %ld final)", particleMother.daughtersIds().back() - particleMother.daughtersIds().front() + 1, N);
                  return {};
                }
              }
              // Get the list of actual final daughters.
              RecoDecay::getDaughters<checkProcess>(particleMother, &arrAllDaughtersIndex, pdgFinParts, depthMax);
              std::cout << "MC Rec: Mother " << indexMother << " has " << arrAllDaughtersIndex.size() - 1 << "NFinalStates" << std::endl;
              for (auto i : arrAllDaughtersIndex) {
                if (i == indexMother) {
                  continue; // Skip the mother itself.
                }
                std::cout << " " << i << " ";
              }
              for (auto i : arrAllDaughtersIndex) {
                if (i == indexMother) {
                  continue; // Skip the mother itself.
                }
                std::cout << " " << particlesMC.rawIteratorAt(i - particlesMC.offset()).pdgCode() << " ";
              }
              std::cout << " " << std::endl;
              //  Check whether the number of actual final daughters is equal to the number of expected final daughters (i.e. the number of provided prongs).
              if (!acceptIncompleteReco && arrAllDaughtersIndex.size() != NDaug) {
                std::cout << "MC Rec: Number of NFinalStates " << arrAllDaughtersIndex.size() << " (expected " << NDaug << ")" << std::endl;
                // LOG(info) << "MC Rec: Rejected: incorrect number ofNFinalStates " << arrAllDaughtersIndex.size() << " (expected " << N << ")";
                // Printf("MC Rec: Rejected: incorrect number ofNFinalStates %ld (expected %ld)", arrAllDaughtersIndex.size(), N);
                return {};
              }
              break;
            }
          }
          // Check that the daughter is in the list of final daughters.
          // (Check that the daughter is not a stepdaughter, i.e. particle pointing to the mother while not being its daughter.)
          bool isDaughterFound = false; // Is the index of this prong among the remaining expected indices of daughters?
          for (std::size_t iD = 1; iD < arrAllDaughtersIndex.size(); ++iD) {
            std::cout << "MC Rec: Checking daughter " << iProng << " index: " << arrDaughtersIndex[iProng] << " against expected index: " << arrAllDaughtersIndex[iD] << std::endl;
            if (arrDaughtersIndex[iProng] == arrAllDaughtersIndex[iD]) {
              arrAllDaughtersIndex[iD] = -1; // Remove this index from the array of expected daughters. (Rejects twin daughters, i.e. particle considered twice as a daughter.)
              isDaughterFound = true;
              break;
            }
          }
          if (!isDaughterFound) {
            std::cout << "MC Rec: Rejected: bad daughter index: " << arrDaughtersIndex[iProng] << " not in the list of final daughters" << std::endl;
            return {};
          }
        }
        // std::cout << "MC Rec: Accepted: m: " << indexMother << std::endl;
        if (sign) {
          *sign = sgn;
        }
        if constexpr (acceptTrackDecay) {
          if (nPiToMu) {
            *nPiToMu = nPiToMuLocal;
          }
          if (nKaToPi) {
            *nKaToPi = nKaToPiLocal;
          }
        }
        if constexpr (acceptTrackIntWithMaterial) {
          if (nInteractionsWithMaterial) {
            *nInteractionsWithMaterial = nInteractionsWithMaterialLocal;
          }
        }
        return arrAllDaughtersIndex;
    }

    std::unordered_map<FinalStatesDMesons, std::vector<int> > finalStates = 
    {
        {FinalStatesDMesons::KKPi, std::vector<int>{-kKPlus, +kKPlus, +kPiPlus}},
        {FinalStatesDMesons::KKPiPi0, std::vector<int>{-kKPlus, +kKPlus, +kPiPlus, +kPi0}},
        {FinalStatesDMesons::KPiPi, std::vector<int>{+kPiPlus, -kKPlus, +kPiPlus}},
        {FinalStatesDMesons::KPiPiPi0, std::vector<int>{+kPiPlus, -kKPlus, +kPiPlus, +kPi0}},
        {FinalStatesDMesons::PiPiPi, std::vector<int>{+kPiMinus, +kPiPlus, +kPiPlus}},
        {FinalStatesDMesons::PiPiPiPi0, std::vector<int>{+kPiMinus, +kPiPlus, +kPiPlus, +kPi0}},
        {FinalStatesDMesons::ProtonPiPi, std::vector<int>{kProton, -kPiPlus, +kPiPlus}},
        {FinalStatesDMesons::ProtonKPi, std::vector<int>{kProton, -kKPlus, +kPiPlus}}
    };

    bool matchChnPdgs(std::vector<int>& arrDaugPdg, std::vector<int> chnExpectedPdgs) {
        // Check daughter's PDG code.
        std::vector<int> usedIdxs = {};
        for (std::size_t iProng = 0; iProng < 3; ++iProng) {
            bool matchPdgProng = false;
            for (int iExpPdg=0; iExpPdg < chnExpectedPdgs.size(); ++iExpPdg) {
                for (int iUsedIdx : usedIdxs) {
                    if (iExpPdg == iUsedIdx) {
                        LOG(info) << "[matchChnPdgs] Skipping already matched PDG code: " << chnExpectedPdgs[iExpPdg];
                        continue; // Skip already matched PDG codes
                    }
                }
                std::cout << "[matchChnPdgs] Checking daughter PDG: " << arrDaugPdg[iProng] << " against expected PDG: " << chnExpectedPdgs[iExpPdg] << std::endl;
                if (arrDaugPdg[iProng] == chnExpectedPdgs[iExpPdg]) {
                    matchPdgProng = true; // Found a match
                    LOG(info) << "[matchChnPdgs] Matched daughter PDG: " << arrDaugPdg[iProng] << " at prong " << iProng;
                    if (chnExpectedPdgs.size() == 3) {
                        // Update final state for 3-prong decays
                        LOG(info) << "[matchChnPdgs] chnExpectedPdgs updated: " << chnExpectedPdgs[0] << " " << chnExpectedPdgs[1] << " " << chnExpectedPdgs[2];
                    }
                    if (chnExpectedPdgs.size() == 4) {
                        // Update final state for 4-prong decays
                        LOG(info) << "[matchChnPdgs] chnExpectedPdgs updated: " << chnExpectedPdgs[0] << " " << chnExpectedPdgs[1] << " " << chnExpectedPdgs[2] << " " << chnExpectedPdgs[3];
                    }
                }
                usedIdxs.push_back(iExpPdg); // Store the index of the matched PDG code
            }
            if (!matchPdgProng) {
                LOG(info) << "[matchChnPdgs] Rejected: bad daughter PDG: " << arrDaugPdg[iProng];
                return false; // No match found for this prong
            }
        }
      return true;
    }

    template <bool matchKinkedDecayTopology = false, bool matchInteractionsWithMaterial = false>
    int matchFinalStateCorrBkgs(aod::McParticles const& mcParticles, auto arrayDaughters, int8_t* flag, int8_t* sign, int8_t* channel, int depth, int8_t* nKinkedTracks, int8_t* nInteractionsWithMaterial) {
        std::vector<int> arrDaugIdxs = {};
        int indexRec = -1; // Index of the matched reconstructed candidate
        for (std::size_t iProng = 0; iProng < 3; ++iProng) {
          if (!arrayDaughters[iProng].has_mcParticle()) {
            return -1;
          }
          auto particleI = arrayDaughters[iProng].mcParticle(); // ith daughter particle
          auto motherI = particleI.template mothers_first_as<aod::McParticles>();
          auto pdgI = particleI.pdgCode();
          auto pdgMotherI = motherI.pdgCode();
          auto pdgMotherII = -1;
          LOG(info) << "Daughter " << iProng << " PDG: " << pdgI << " motherI: " << pdgMotherI;
        }
        LOG(info) << "Matching daughters ... ";
        std::array<int, 4> arrFinDecayProd = {kPiPlus, kKPlus, kProton, kPi0};
        std::vector<int> mothersPdgCodes = {Pdg::kDPlus, Pdg::kDS, Pdg::kDStar, Pdg::kLambdaCPlus, Pdg::kXiCPlus};
        int matchedMotherId = 0;
        if constexpr (matchKinkedDecayTopology && matchInteractionsWithMaterial) {
          arrDaugIdxs = getMatchedMCRecDaugIdxs<false, false, true, true, true>(mcParticles, arrayDaughters, mothersPdgCodes, arrFinDecayProd, indexRec, matchedMotherId, true, sign, depth, nKinkedTracks, nInteractionsWithMaterial);
        } else if constexpr (matchKinkedDecayTopology && !matchInteractionsWithMaterial) {
          arrDaugIdxs = getMatchedMCRecDaugIdxs<false, false, true, true, false>(mcParticles, arrayDaughters, mothersPdgCodes, arrFinDecayProd, indexRec, matchedMotherId, true, sign, depth, nKinkedTracks);
        } else if constexpr (!matchKinkedDecayTopology && matchInteractionsWithMaterial) {
          arrDaugIdxs = getMatchedMCRecDaugIdxs<false, false, true, false, true>(mcParticles, arrayDaughters, mothersPdgCodes, arrFinDecayProd, indexRec, matchedMotherId, true, sign, depth, nullptr, nInteractionsWithMaterial);
        } else {
          arrDaugIdxs = getMatchedMCRecDaugIdxs<false, false, true, false, false>(mcParticles, arrayDaughters, mothersPdgCodes, arrFinDecayProd, indexRec, matchedMotherId, true, sign, depth);
        }
        LOG(info) << "Size of arrDaugIdxs: " << arrDaugIdxs.size() << ", indexRec: " << indexRec;
        if (arrDaugIdxs.size() > 0) {
          std::vector<int> arrProngPdg;
          for (std::size_t iProng = 0; iProng < 3; ++iProng) {
            if (arrayDaughters[iProng].has_mcParticle()) { // first one is the mother index
              arrProngPdg.push_back((*sign) * arrayDaughters[iProng].mcParticle().pdgCode());
              std::cout << "Daughter " << iProng << " PDG: " << arrProngPdg[iProng] << ", sign: " << *sign << std::endl;
            } else {
              LOG(info) << "[matchFinalStateDMeson] Daughter has no MC particle!";
              return 0;
            }
          }
          LOG(info) << "Matched candidate!";
          for (const std::pair<int, std::vector<int> >& finalState : finalStates) {
            if (matchChnPdgs(arrProngPdg, finalState.second)) {
              LOG(info) << "[matchFinalStateDMeson] Final state PDGs: ";
              for (int iExpPdg : finalState.second) {
                LOG(info) << "[matchFinalStateDMeson] " << iExpPdg;
              }
              *flag = (*sign) * finalState.first + 20 * matchedMotherId;
              LOG(info) << "[matchFinalStateDMeson] Flag set to: " << static_cast<int>(*flag) << " sign: " << static_cast<int>(*sign) << " for channel: " << finalState.first;
              break;
            }
          }
          // Flag the resonant decay channel
            std::cout << "Checking for resonant decay channel..." << std::endl;
            std::vector<int> arrResoDaughIndex = {};
            RecoDecay::getDaughters(mcParticles.rawIteratorAt(indexRec), &arrResoDaughIndex, std::array{0}, 1);
            int NDaughtersResonant = 2;
            std::vector<int> arrPDGDaugh = {};
            if (arrResoDaughIndex.size() == NDaughtersResonant) {
              for (auto iProng = 0u; iProng < arrResoDaughIndex.size(); ++iProng) {
                auto daughI = mcParticles.rawIteratorAt(arrResoDaughIndex[iProng]);
                arrPDGDaugh.push_back(std::abs(daughI.pdgCode()));
                std::cout << "Resonant daughter " << iProng << " PDG: " << arrPDGDaugh[iProng] << std::endl;
              }
              flagResonantDecay(mothersPdgCodes[matchedMotherId], channel, arrPDGDaugh);
            }
        }
        return indexRec;
    }

} // namespace o2::hf_corrbkg

#endif // PWGHF_CORE_CORRELATEDBKGTAGGER_H_
