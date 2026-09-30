// Models + SAMPLE content.
// Replace the sample lists below with your own API / JSON source.
// Each audio/book needs a stable unique `id` (used for downloads).

const kCategories = ['Zote', 'Aqeedah', 'Fiqh', 'Tafseer', 'Seerah', 'Hadith'];

class AudioItem {
  final String id;
  final String title;
  final String sheikh;
  final String category;
  final String type; // Darsa | Mihadhara | Rudud
  final String url;
  final Duration duration;

  const AudioItem({
    required this.id,
    required this.title,
    required this.sheikh,
    required this.category,
    required this.type,
    required this.url,
    required this.duration,
  });
}

class BookItem {
  final String id;
  final String title;
  final String author;
  final double sizeMb;
  final String url;

  const BookItem({
    required this.id,
    required this.title,
    required this.author,
    required this.sizeMb,
    required this.url,
  });
}

class QaItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final bool isRudud;
  final AudioItem? audio; // optional audio response (Rudud)

  const QaItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.isRudud = false,
    this.audio,
  });
}

// ---------------------------------------------------------------------------
// SAMPLE DATA (test mp3/pdf links - swap for real content)
// ---------------------------------------------------------------------------
const _mp3 = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-';
const _pdf =
    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

final List<AudioItem> sampleAudios = [
  AudioItem(id: 'a1', title: 'Nguzo Sita za Imani', sheikh: 'Sheikh Ali Juma', category: 'Aqeedah', type: 'Darsa', url: '${_mp3}1.mp3', duration: const Duration(minutes: 6, seconds: 12)),
  AudioItem(id: 'a2', title: 'Sharti na Nguzo za Swala', sheikh: 'Sheikh Salim Omar', category: 'Fiqh', type: 'Darsa', url: '${_mp3}2.mp3', duration: const Duration(minutes: 7, seconds: 5)),
  AudioItem(id: 'a3', title: 'Tafsiri ya Suratul Fatiha', sheikh: 'Sheikh Khamis Mussa', category: 'Tafseer', type: 'Darsa', url: '${_mp3}3.mp3', duration: const Duration(minutes: 5, seconds: 44)),
  AudioItem(id: 'a4', title: 'Maisha ya Mtume ﷺ - Makka', sheikh: 'Sheikh Ali Juma', category: 'Seerah', type: 'Mihadhara', url: '${_mp3}4.mp3', duration: const Duration(minutes: 5, seconds: 53)),
  AudioItem(id: 'a5', title: 'Maana ya Tawhid', sheikh: 'Sheikh Salim Omar', category: 'Aqeedah', type: 'Mihadhara', url: '${_mp3}5.mp3', duration: const Duration(minutes: 5, seconds: 38)),
  AudioItem(id: 'a6', title: 'Hukumu za Zakah', sheikh: 'Sheikh Khamis Mussa', category: 'Fiqh', type: 'Darsa', url: '${_mp3}6.mp3', duration: const Duration(minutes: 6, seconds: 22)),
  AudioItem(id: 'a7', title: 'Hijra ya Mtume ﷺ', sheikh: 'Sheikh Ali Juma', category: 'Seerah', type: 'Mihadhara', url: '${_mp3}7.mp3', duration: const Duration(minutes: 6, seconds: 14)),
  AudioItem(id: 'a8', title: 'Hadithi ya Jibril', sheikh: 'Sheikh Salim Omar', category: 'Hadith', type: 'Darsa', url: '${_mp3}8.mp3', duration: const Duration(minutes: 5, seconds: 27)),
];

final List<BookItem> sampleBooks = [
  const BookItem(id: 'b1', title: 'Nguzo Tatu za Msingi', author: 'Muhammad bin Abdulwahhab', sizeMb: 1.2, url: _pdf),
  const BookItem(id: 'b2', title: 'Arbaeen Nawawi', author: 'Imam an-Nawawi', sizeMb: 2.4, url: _pdf),
  const BookItem(id: 'b3', title: 'Fiqh ya Swala', author: 'Sheikh Salim Omar', sizeMb: 3.1, url: _pdf),
  const BookItem(id: 'b4', title: 'Sira ya Mtume ﷺ', author: 'Sheikh Ali Juma', sizeMb: 5.6, url: _pdf),
  const BookItem(id: 'b5', title: 'Adabu za Mwanafunzi', author: 'Sheikh Khamis Mussa', sizeMb: 0.9, url: _pdf),
  const BookItem(id: 'b6', title: 'Tafsiri Fupi ya Juzuu Amma', author: 'Sheikh Khamis Mussa', sizeMb: 4.3, url: _pdf),
];

final List<QaItem> sampleQa = [
  const QaItem(id: 'f1', category: 'Fiqh', question: 'Je, mtu aliyesahau kusoma Fatiha katika swala, swala yake inasihi?', answer: 'Kusoma Fatiha ni nguzo ya swala. Ikiwa mtu amesahau na akakumbuka kabla ya kutoa salamu, anairudia rakaa hiyo na kufanya sijida ya kusahau. Ikiwa amekumbuka baada ya kutoa salamu na muda umepita, anarudia swala hiyo.'),
  const QaItem(id: 'f2', category: 'Fiqh', question: 'Ni lini zakah ya mali inapowajibika?', answer: 'Zakah inawajibika mali inapofikia nisabu (kiwango cha chini) na ikapita mwaka mmoja wa Hijria. Kiwango ni 2.5% ya mali inayotakiwa kutolewa zakah.'),
  const QaItem(id: 'f3', category: 'Aqeedah', question: 'Nini hukumu ya kwenda kwa waganga wa kienyeji?', answer: 'Haijuzu kwenda kwa wanaodai kujua ghaibu au kutibu kwa njia zisizo za kisheria. Mwislamu anatakiwa kutibiwa kwa dawa zilizo halali na Ruqya ya kisheria kwa Qur\'an na dua za Mtume ﷺ.'),
  const QaItem(id: 'f4', category: 'Hadith', question: 'Je, ni sahihi kusema "Bismillah" kabla ya kula?', answer: 'Ndiyo, ni Sunna kusema "Bismillah" kabla ya kula. Ukisahau mwanzoni, sema: "Bismillahi awwalahu wa akhirahu".'),
  const QaItem(id: 'f5', category: 'Fiqh', question: 'Je, mwanamke mwenye hedhi anaweza kufunga?', answer: 'Hapana, hafungi wakati wa hedhi, lakini analipa siku hizo baada ya Ramadhani. Hahitaji kulipa swala alizoziacha kipindi hicho.'),
  QaItem(
    id: 'r1', isRudud: true, category: 'Aqeedah',
    question: 'Rudd: Shubha kuhusu kuomba dua kupitia watu waliokufa',
    answer: 'Dua ni ibada, na ibada haielekezwi ila kwa Allah pekee. Allah anasema kuwa Yeye yu karibu na anajibu dua ya anayemwomba. Hakuna haja ya mtu wa kati.',
    audio: AudioItem(id: 'ra1', title: 'Rudd: Dua kwa Allah Pekee', sheikh: 'Sheikh Ali Juma', category: 'Aqeedah', type: 'Rudud', url: '${_mp3}9.mp3', duration: const Duration(minutes: 4, seconds: 20)),
  ),
  QaItem(
    id: 'r2', isRudud: true, category: 'Hadith',
    question: 'Rudd: Kukanusha Hadith za Mtume ﷺ na kutegemea Qur\'an peke yake',
    answer: 'Qur\'an yenyewe inatuamuru kumtii Mtume ﷺ. Sunna ndiyo tafsiri ya vitendo ya Qur\'an - bila Sunna hatuwezi kujua idadi ya rakaa za swala wala namna ya Hijja.',
    audio: AudioItem(id: 'ra2', title: 'Rudd: Umuhimu wa Sunna', sheikh: 'Sheikh Salim Omar', category: 'Hadith', type: 'Rudud', url: '${_mp3}10.mp3', duration: const Duration(minutes: 6, seconds: 3)),
  ),
  const QaItem(
    id: 'r3', isRudud: true, category: 'Fiqh',
    question: 'Rudd: Je, Uislamu unamdhulumu mwanamke?',
    answer: 'Uislamu umempa mwanamke haki ya kumiliki mali, kurithi, kusoma na kuchagua mume - haki ambazo hazikuwepo katika jamii nyingi za wakati huo. Heshima yake imehifadhiwa kama mama, dada, mke na binti.',
  ),
];
