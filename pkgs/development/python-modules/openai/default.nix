{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatchling
# propagated
, httpx
, pydantic
, typing-extensions
, anyio
, distro
, sniffio
, cached-property
, tqdm
# optional
, numpy
, pandas
, pandas-stubs
# tests
, pytestCheckHook
, pytest-asyncio
, pytest-mock
, respx
, dirty-equals
}:

buildPythonPackage rec {
  pname = "openai";
  version = "1.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7.1";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-v623+dxttNDAfVh+2h64SqT4FvaOGRe0zvHCchIy/Wg=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
    pydantic
    typing-extensions
    anyio
    distro
    sniffio
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
  ];

  passthru.optional-dependencies = {
    datalib = [
      numpy
      pandas
      pandas-stubs
    ];
  };

  pythonImportsCheck = [
    "openai"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    respx
    dirty-equals
  ];

  disabledTests = [
    # Tests make network requests
    "test_streaming_response"
    "test_copy_build_request"
  ];

  disabledTestPaths = [
    # Test makes network requests
    "tests/api_resources"
  ];

  meta = with lib; {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    changelog = "https://github.com/openai/openai-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
  };
}
