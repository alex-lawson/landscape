SkylineTemplates = {
    Mountains = {
        noiseConfig = { 
            noiseType = "min",
            sources = {
                {
                    noiseType = "rand",
                    range = {-20, 90}
                },
                {
                    noiseType = "rand",
                    range = {-20, 90}
                }
            }
        },
        sampleInterval = {50, 100},
        yRange = {0, 0.2}
    },
    LowMountains = {
        noiseConfig = {
            noiseType = "min",
            sources = {
                {
                    noiseType = "rand",
                    range = {-10, 50}
                },
                {
                    noiseType = "rand",
                    range = {-10, 50}
                },
                {
                    noiseType = "rand",
                    range = {-10, 50}
                }
            }
        },
        sampleInterval = {70, 100},
        yRange = {0.1, 0.4}
    },
    Hills = {
        noiseConfig = {
            noiseType = "sum",
            sources = {
                {
                    noiseType = "perlin",
                    amp = 50,
                    freq = 0.005
                },
                {
                    noiseType = "perlin",
                    amp = 30,
                    freq = 0.005
                }
            }
        },
        sampleInterval = 10,
        yRange = {0.3, 0.9}
    },
    LowHills = {
        noiseConfig = {
            noiseType = "sum",
            sources = {
                {
                    noiseType = "perlin",
                    amp = 30,
                    freq = 0.008
                },
                {
                    noiseType = "perlin",
                    amp = 20,
                    freq = 0.007
                }
            }
        },
        sampleInterval = 10,
        yRange = {0.6, 1.0}
    }
}