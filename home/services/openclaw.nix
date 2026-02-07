{ pkgs, inputs, ... }:

{
  imports = [
    inputs.openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;
    documents = ./openclaw/docs; # Path to documents directory relative to this file
    
    # Secrets should be handled securely. 
    # For now, ensure you have ~/.secrets/openclaw.json or similar if required by the module.
    # Refer to documentation for secret management.
  };
}
