{
  python3,
  stdenv,
  lib,
}: let
  python = python3.withPackages (ps: [ps.pandas ps.seaborn]);
  pythonScript = {
    name,
    script,
    data,
    utils ? [],
    outputs,
  }: let
    filter = lib.fileset.fileFilter (n: n.name == script || builtins.elem n.name utils) ./.;
    absOutputs = lib.strings.concatMapStringsSep " " (f: "$out/${f}") outputs;
  in
    stdenv.mkDerivation {
      inherit name;
      src = lib.fileset.toSource {
        root = ./.;
        fileset = filter;
      };
      buildInputs = [python];
      buildPhase = ''
        ls $src
        mkdir $out
        python ${script} ${data} ${absOutputs}
      '';
    };
  all-data = pythonScript {
    name = "all-data";
    script = "all.py";
    data = "${../results}/*";
    outputs = ["data.csv"];
  };
  makeData = name: script:
    pythonScript {
      inherit name script;
      data = "${all-data}/data.csv";
      outputs = ["data.csv"];
    };
  plotExtensions = ["png" "pdf" "svg"];
  makePlots = name: script: dataDrv: utils:
    pythonScript {
      inherit name script;
      data = "${dataDrv}/data.csv";
      utils = ["utils.py"]++utils;
      outputs = builtins.map (e: "plot.${e}") plotExtensions;
    };
in rec {
  inherit all-data;

  test-data = makeData "test-data" "test.data.py";
  test-plot = makePlots "test-plot" "test.plot.py" test-data [];
}
