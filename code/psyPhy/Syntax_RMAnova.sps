
DATASET ACTIVATE DataSet1.
GLM passive vestib proprio active
  /WSFACTOR=factor_proprio 2 Polynomial factor_vestib 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(factor_proprio*factor_vestib factor_vestib*factor_proprio factor_proprio 
    factor_vestib)
  /EMMEANS=TABLES(factor_proprio) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(factor_vestib) COMPARE ADJ(SIDAK)
  /EMMEANS=TABLES(factor_proprio*factor_vestib) 
  /PRINT=DESCRIPTIVE TEST(MMATRIX) HOMOGENEITY 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=factor_proprio factor_vestib factor_proprio*factor_vestib.
