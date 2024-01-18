{
  python3,
  stdenv,
  lib,
  symlinkJoin,
}: let
  python = python3.withPackages (ps: [ps.pandas ps.seaborn]);
  pythonScript = {
    name,
    script,
    utils ? [],
    data,
    outputs,
  }: let
    absOutputs = lib.strings.concatMapStringsSep " " (f: "$out/${f}") outputs;
    scriptName = lib.lists.last (builtins.split "/" (toString script));
  in
    stdenv.mkDerivation {
      inherit name;
      src = lib.fileset.toSource {
        root = ./.;
        fileset = lib.fileset.unions ([script] ++ utils);
      };
      buildInputs = [python];
      buildPhase = ''
        mkdir $out
        python ${scriptName} ${data} ${absOutputs}
      '';
    };
  all-data = pythonScript {
    name = "all-data";
    script = ./all.py;
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
      utils = [./utils.py] ++ utils;
      outputs = builtins.map (e: "plot.${e}") plotExtensions;
    };
in rec {
  inherit all-data;

  test-data = makeData "test-data" ./test.data.py;
  test-plot = makePlots "test-plot" ./test.plot.py test-data [];

  all-plots = symlinkJoin {
    name = "all-plots";
    paths = [test-plot];
  };
}
