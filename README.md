# phenofit in Julia

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kongdd.github.io/phenofit.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kongdd.github.io/phenofit.jl/dev)
[![Codecov](https://codecov.io/gh/kongdd/phenofit.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/kongdd/phenofit.jl)

> Dongdong Kong

This package provides implementations for smoothing algorithm for remote sensing vegetation indexes.

# Installation
```
using Pkg
Pkg.add(url = "https://github.com/kongdd/phenofit.jl")
```

## Tasklist 

- [x] weighted Whittaker-Henderson smoothing and interpolation
- [x] weighted Savitzky Golay filter
- [ ] HANTS
- [ ] Double Logistics
- [ ] Growing season dividing
- [ ] Phenological metrics

# References

[1]   **Kong, D.**, Zhang, Y., Wang, D., Chen, J., & Gu, X. (2020). Photoperiod Explains the Asynchronization Between Vegetation Carbon Phenology and Vegetation Greenness Phenology. **Journal of Geophysical Research: Biogeosciences**, 125(8), e2020JG005636. https://doi.org/10.1029/2020JG005636

[2]   **Kong, D.**, Zhang, Y., Gu, X., & Wang, D. (2019). A robust method for reconstructing global MODIS EVI time series on the Google Earth Engine. **ISPRS Journal of Photogrammetry and Remote Sensing**, 155, 13–24. (**Q1,** **IF=7.319**)

[3]   Zhang, Q.\*, **Kong, D.\***, Shi, P., Singh, V.P., Sun, P., 2018. Vegetation phenology on the Qinghai-Tibetan Plateau and its response to climate change (1982–2013). **Agricultural and Forest Meteorology**. 248, 408-417. (**Q1**，****IF=4.189****）

<!-- ```bash
wc -l src/*/*
``` -->
