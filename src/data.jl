function init_data()
    ENV["DATADEPS_ALWAYS_ACCEPT"] = "true"    
    register(DataDep(
        "HumanGEM v1.19",
        """
        Human-GEM: The generic genome-scale metabolic model of Homo sapiens
        J. L. Robinson, P. Kocabas, H. Wang, P.-E. Cholley, et al. An atlas of human metabolism. Sci. Signal. 13, eaaz1482 (2020). doi:10.1126/scisignal.aaz1482
        """
        ,
        "https://raw.githubusercontent.com/SysBioChalmers/Human-GEM/refs/tags/v1.19.0/model/Human-GEM.xml",
        "5aa161fbd52e79051dc445d87965db0716219d95ef1a6f0a8c5bd51fd60e075c",
    ))
end

human_gem_file() = datadep"HumanGEM v1.19/Human-GEM.xml"
human_gem() = readSBML(human_gem_file())