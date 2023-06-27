{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  name = "irevenko";
  rev = "e6c3f625bfad7c9d95d0f20a658fc3fda5cb4e76";

  vendorHash = "sha256-m3k/f2W+aLUf67c0WmTIN2Ym+K+/DoYe4shau8ccOE4=";

  src = fetchFromGitHub {
    owner = "irevenko";
    repo = "koneko";
    rev = "${rev}";
    sha256 = "sha256-5QMqlZrGEzGwmIr3cB3N12A/bYwoRs94bmPnkIUWOZ8=";
  };

  meta = with lib; {
    description = "nyaa.si terminal BitTorrent tracker";
    license = licenses.mit;
    homepage = "https://github.com/irevenko/koneko";
    maintainers = with maintainers; [ludovicopiero];
  };
}
