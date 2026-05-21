{ ... }:
{
  imports = [
    ../../modules
    ../../modules/discord
    ../../modules/electronics.nix
    ../../modules/cloudflare
  ];

  programs.brave.extensions = [
    { id = "nngceckbapebfimnlniiiahkandclblb"; }
    { id = "kpmjjdhbcfebfjgdnpjagcndoelnidfj"; }
    { id = "plhaalebpkihaccllnkdaokdoeaokmle"; }
    { id = "eciepnnimnjaojlkcpdpcgbfkpcagahd"; }
  ];

  programs.google-chrome.extensions = [
    { id = "nngceckbapebfimnlniiiahkandclblb"; }
    { id = "kpmjjdhbcfebfjgdnpjagcndoelnidfj"; }
    { id = "plhaalebpkihaccllnkdaokdoeaokmle"; }
    { id = "eciepnnimnjaojlkcpdpcgbfkpcagahd"; }
  ];
}
