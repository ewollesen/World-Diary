class NameGenerator

  DEFAULT_OPTIONS = {
    min_syllables: 1,
    max_syllables: 4,
  }

  def initialize(options={})
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def generate
    min_syl = [1, @options[:min_syllables]].max
    max_syl = [10, @options[:max_syllables]].min
    num_syls = (min_syl..max_syl).to_a.sample
    syls = []

    syls << start_syl.sample
    2.upto(num_syls - 1) {syls << mid_syl.sample}
    syls << end_syl.sample if num_syls >= 2

    syls.join("").capitalize
  end

  def generate_n(n=10)
    names = []

    while names.size < n
      candidate = generate
      names << candidate unless names.include?(candidate)
    end

    names
  end


  private

  def start_syl
    [
     "ad",
     "al",
     "are",
     "at",
     "ban",
     "bert",
     "ce",
     "chris",
     "con",
     "del",
     "dra",
     "em",
     "er",
     "gar",
     "gyr",
     "hin",
     "hon",
     "im",
     "ir",
     "iss",
     "kal",
     "kel",
     "mal",
     "mel",
     "min",
     "mor",
     "on",
     "or",
     "pan",
     "per",
     "pin",
     "pir",
     "ra",
     "ray",
     "re",
     "ri",
     "ror",
     "roth",
     "ry",
     "sam",
     "shy",
     "sul",
     "tai",
     "tan",
     "thom",
     "thur",
     "tor",
     "unt",
     "ur",
     "vor",
    ]
  end


  def mid_syl
    [
     "ach",
     "ack",
     "ad",
     "age",
     "ald",
     "ale",
     "an",
     "ang",
     "ar",
     "ard",
     "as",
     "ash",
     "at",
     "ath",
     "augh",
     "aw",
     "ban",
     "bel",
     "bur",
     "cha",
     "che",
     "cor",
     "dan",
     "dar",
     "del",
     "den",
     "dra",
     "dyn",
     "ech",
     "eld",
     "elm",
     "em",
     "en",
     "end",
     "eng",
     "enth",
     "er",
     "ess",
     "est",
     "et",
     "ex",
     "gar",
     "gha",
     "hat",
     "hin",
     "hon",
     "ia",
     "ight",
     "ild",
     "im",
     "ina",
     "ine",
     "ing",
     "ir",
     "is",
     "iss",
     "it",
     "kal",
     "kel",
     "kim",
     "kin",
     "ler",
     "lor",
     "lye",
     "mel",
     "mor",
     "mos",
     "nal",
     "ny",
     "nys",
     "old",
     "om",
     "on",
     "or",
     "orm",
     "os",
     "ough",
     "per",
     "pol",
     "qua",
     "que",
     "rad",
     "rak",
     "ran",
     "ray",
     "ril",
     "ris",
     "rod",
     "roth",
     "ryn",
     "sam",
     "say",
     "ser",
     "shy",
     "skel",
     "sul",
     "tai",
     "tan",
     "tas",
     "ther",
     "tia",
     "tin",
     "ton",
     "tor",
     "tur",
     "um",
     "und",
     "unt",
     "urn",
     "usk",
     "ust",
     "ver",
     "ves",
     "vor",
     "wor",
     "yer",
    ]
  end

  def end_syl
    [
     "an",
     "as",
     "der",
     "fer",
     "ic",
     "in",
     "ith",
     "nor",
     "on",
     "yth",
    ]
  end

end
