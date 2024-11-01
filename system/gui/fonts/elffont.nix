{ pkgs ? import <nixpkgs> { }, ... }:

let
  font-elffont = { version, rev ? version, hash

    }:
    pkgs.stdenv.mkDerivation {

      pname = "font-elffont";
      inherit version;

      src = pkgs.fetchFromGitHub {
        owner = "justfont";
        repo = "Elffont";
        inherit rev hash;
      };

      installPhase = ''
        runHook preInstall

        install -m444 -Dt $out/share/fonts/opentype fonts/*.otf

        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "Font Elffont - OTF Font";
        longDescription = ''
          重新定義ㄅㄆㄇ！台灣人才懂的史詩注音字型
          2024 年 8 月，書法家 做作的Daphne 在社群上分享了數張「精靈文」草稿，並在貼文中表達未來開放下載使用的預期。
          作為字型公司的 justfont 以字型化協力的角色加入計畫，共同完成「精靈文」。旨在打造台灣人專屬的閱讀體驗。
        '';
        license = ''
          Copyright 2024 做作的Daphne & justfont 

          - 本字型之智慧財產權為「做作的Daphne」與「justfont」共同所有
          - 不需付費、知會作者，即可自由使用此字型，亦可做商業應用。
          - 不得直接販售本字型，亦不得製作為字帖釋出或銷售。
          - 本字型未經准許，禁止進行修改或重製、販售。
          - 對本字型的下載、安裝、與安裝後相關之問題，及可能導致之一切損害，製作團隊皆不承擔相關責任。
          - 製作團隊不擔保字型內容，請自行確認文字之正確性。
          - 「做作的Daphne」與「justfont」保留隨時修改、變更、暫停或終止本內容之權利。

          - The intellectual property rights for this typeface are jointly owned by '做作的Daphne' and 'justfont'.
          - This typeface is free to use, including for commercial purposes, without payment or prior notification to the creators.
          - The typeface may not be sold directly, nor may it be released or sold in template or copyable form.
          - Modifications, reproductions, or sales of this typeface are prohibited without prior authorization.
          - The creators assume no liability for any issues or damages that may arise from downloading, installing, or using this typeface.
          - No warranty is provided for the accuracy of the typeface content; users are responsible for verifying text accuracy.
          - '做作的Daphne' and 'justfont' reserve the right to modify, alter, suspend, or terminate this content at any time.
        '';
        homepage = "https://github.com/justfont/Elffont";
      };
    };
  # Define the specific font version with hash
in {
  v1 = font-elffont {
    version = "v1.0";
    rev = "v1.0";
    hash = "sha256-SsrPPWKPm2Y6f/lHbL74AWCJRJGmqXSn2lHK+f7wH1g=";
  };
}
