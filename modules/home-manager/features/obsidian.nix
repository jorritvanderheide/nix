{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      obsidian
      ollama
      open-webui
    ];
    sessionVariables = {
      OLLAMA_ORIGINS = "*";
    };
  };

  myHomeManager.impermanence.directories = [
    ".config/obsidian"
    ".ollama"
  ];
}
