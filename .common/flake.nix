{
  inputs = {
    common.url = ./common;
    domain = {
      url = ./domain;
      inputs.common.follows = "common";
    };
  };

  outputs = inputs: inputs.domain;
}
