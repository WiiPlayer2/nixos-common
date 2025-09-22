{ buildPythonPackage
, fetchPypi

, setuptools
, setuptools-scm

, weasyprint
, markdown
, hurry-filesize
, beautifulsoup4
, typing-extensions
}:

let
  pname = "eml2pdf";
  version = "0.1.1";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sKiLVXwYfbNujdWmUKEmuxfCFsKsWjFJAUqeXTHjQao=";
  };

  weasyprint' = weasyprint.overrideAttrs {
    src = fetchPypi {
      inherit (weasyprint) pname;
      version = "64.1";
      hash = "sha256-KLAvLGQJuvzhsSINnXanNFh1vTvQjE9t+/UQu5KpR1c=";
    };
  };

  beautifulsoup4' = beautifulsoup4.overridePythonAttrs (prev: {
    src = fetchPypi {
      inherit (beautifulsoup4) pname;
      version = "4.13.5";
      hash = "sha256-XnATE4KTDnw94zRQovVKY9XksZOG6rQ6WzTVlCaPNpU=";
    };

    patches = [ ];

    dependencies = [
      typing-extensions
    ];
  });
in
buildPythonPackage {
  inherit pname version src;

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    setuptools-scm
    weasyprint'
    markdown
    hurry-filesize
    beautifulsoup4'
  ];

  passthru.skipUpdate = true;
}
