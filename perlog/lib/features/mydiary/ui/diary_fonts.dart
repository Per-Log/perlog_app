class DiaryFonts {
  DiaryFonts._();

  static const nanumPen = 'DiaryNanumPen';
  static const hiMelody = 'DiaryHiMelody';
  static const griun = 'DiaryGriun';
  static const hakgyo = 'DiaryHakgyo';
  static const kangwon = 'DiaryKangwon';
  static const maeil = 'DiaryMaeil';
  static const ssAnt = 'DiarySSAnt';
  static const ssronet = 'DiarySSRONET';
  static const yoonDaehan = 'DiaryYoonDaehan';
  static const yoonManseh = 'DiaryYoonManseh';
  static const yoonMinguk = 'DiaryYoonMinguk';

  static const all = [
    nanumPen,
    hiMelody,
    griun,
    hakgyo,
    kangwon,
    maeil,
    ssAnt,
    ssronet,
    yoonDaehan,
    yoonManseh,
    yoonMinguk,
  ];
}

class DiaryFontConfig {
  static const Map<String, double> fontSizeScale = {
    DiaryFonts.nanumPen: 1.2,
    DiaryFonts.hiMelody: 1.0,
    DiaryFonts.griun: 1.0,
    DiaryFonts.hakgyo: 1.1,
    DiaryFonts.kangwon: 1.2,
    DiaryFonts.maeil: 1.1,
    DiaryFonts.ssAnt: 1.0,
    DiaryFonts.ssronet: 1.1,
    DiaryFonts.yoonDaehan: 1.0,
    DiaryFonts.yoonManseh: 0.9,
    DiaryFonts.yoonMinguk: 1.0,
  };
}