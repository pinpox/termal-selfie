with import <nixpkgs> { };

let

  pythonPackages = python3Packages;
  python-reqs = ./requirements.txt;

in pkgs.mkShell rec {

  name = "tf-ansible-env";
  venvDir = "./.venv";
  buildInputs = [
    pythonPackages.python
    pythonPackages.venvShellHook
    pythonPackages.setuptools
    zlib
    opencv

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    pythonPackages.numpy
    pythonPackages.requests

    # In this particular example, in order to compile any binary extensions they may
    # require, the Python modules listed in the hypothetical requirements.txt need
    # the following packages to be installed locally:
    taglib
    openssl
    git
    libxml2
    libxslt
    libzip
    zlib

  ];

  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''

    function source_check() {
      if [ -f "$1" ]; then
          source $1
          echo "Sourced: $1"
      else
          echo "Error: $1 is missing"
          exit 1
      fi
    }
    export LD_LIBRARY_PATH=${
      lib.strings.makeLibraryPath [ zlib stdenv.cc.cc.lib libGL glib ]
    }:$LD_LIBRARY_PATH;

    echo "Activating python venv"
    source_check ./.venv/bin/activate

    echo "Installing requirements.txt"
    pip install -r ${python-reqs}
  '';
}
