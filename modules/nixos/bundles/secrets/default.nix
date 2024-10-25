{inputs, ...}: {
  # Agenix package
  # TODO: Add dynamic system selection
  environment.systemPackages = [
    inputs.agenix.packages."x86_64-linux".default
  ];
}
