from sirius import DFT_ground_state_find
from sirius.ot import ApplyHamiltonian

# perform a single SCF iteration
res = DFT_ground_state_find(config='sirius.json', num_dft_iter=1)
kset = res['kpointset']
H = ApplyHamiltonian(res['hamiltonian'], kset)
density = res['density']
potential = res['potential']

# obtain the PW coefficients as vector
X = kset.C
# occupation numbers
fn = kset.fn

# compute ∇E(X)
HX = H@X * fn
