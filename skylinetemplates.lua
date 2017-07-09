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
    Mesas = {
        noiseConfig = {
            noiseType = "select",
            selectSource = {
                noiseType = "perlin",
                freq = 0.003,
                offset = -0.2
            },
            aSource = {
                noiseType = "select",
                selectSource = {
                    noiseType = "perlin",
                    freq = 0.005
                },
                aSource = {
                    noiseType = "rand",
                    range = {40, 45}
                },
                bSource = {
                    noiseType = "rand",
                    range = {50, 55}
                }
            },
            bSource = {
                noiseType = "min",
                sources = {
                    {
                        noiseType = "perlin",
                        amp = 40,
                        freq = 0.001
                    },
                    {
                        noiseType = "perlin",
                        amp = 5,
                        freq = 0.007,
                        offset = -15
                    }
                }
            }
        },
        sampleInterval = {5, 15},
        yRange = {0.1, 0.5}
    },
    Hills = {
        noiseConfig = {
            noiseType = "sum",
            sources = {
                {
                    noiseType = "perlin",
                    amp = 20,
                    freq = 0.005
                },
                {
                    noiseType = "perlin",
                    amp = 10,
                    freq = 0.01,
                    offset = 15
                }
            }
        },
        sampleInterval = 10,
        yRange = {0.3, 0.9}
    },
    LowHills = {
        noiseConfig = {
            noiseType = "max",
            sources = {
                {
                    noiseType = "perlin",
                    amp = 15,
                    freq = 0.008
                },
                {
                    noiseType = "perlin",
                    amp = 10,
                    freq = 0.007,
                    offset = 10
                }
            }
        },
        sampleInterval = 10,
        yRange = {0.6, 1.0}
    }
}
