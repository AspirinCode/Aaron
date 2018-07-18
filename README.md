# Aaron
AARON 1.0, An Automated Reaction Optimizer for New catalysts

We are currently merging several development branches of AARON and AaronTools, to be released soon as along with accompanying documentation.

<b>Please check back in early August!</b>

AARON is a computational toolkit to automate the QM-based geometry optimization of transition state and intermediate structures for homogeneous catalytic reactions. It is built using <a href="https://github.com/QChASM/AaronTools">AaronTools</a>.

AARON does not implement new electronic structure methods or geometry optimization algorithms.  Instead, it is essentially an interface to Gaussian09 that automates computations.  Briefly, given a set of TS and intermediate geometries for a given catalytic reaction, AARON can automatically compute analogous structures for similar catalysts/ligands and substrates.  In this way, users can screen potential catalysts and substrates for a given reaction by predicting the activity and selectivity of a given catalyst/substrate combination.
