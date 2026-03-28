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

  static String getDisplayName(String font) {
    switch (font) {
      case nanumPen:
        return '나눔펜';
      case hiMelody:
        return '하이멜로디';
      case griun:
        return '그리운 또박';
      case hakgyo:
        return '학교안심';
      case kangwon:
        return '강원교육 새음';
      case maeil:
        return '매일 옥자';
      case ssAnt:
        return 'SSAnt';
      case ssronet:
        return '손글씨';
      case yoonDaehan:
        return '윤대한';
      case yoonManseh:
        return '윤만세';
      case yoonMinguk:
        return '윤민국';
      default:
        return font;
    }
  }
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

