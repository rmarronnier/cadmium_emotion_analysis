require "./spec_helper"

describe Cadmium::EmotionAnalysis do
  subject = Cadmium::EmotionAnalysis::Intensity.new

  it "should have language keys" do
    subject.data.language_word_emotion_score_hash.keys.should eq(["ps", "en", "es", "kn", "km", "sn", "sl", "zh", "sv", "so", "hi", "ha", "be", "fa", "yi", "id", "sm", "am", "my", "zu", "tl", "sq", "it", "ku", "lb", "th", "lv", "uz", "ta", "gd", "ig", "ne", "ar", "ceb", "lt", "is", "jw", "ml", "lo", "te", "ur", "yo", "bg", "fi", "la", "mg", "et", "si", "pl", "hmn", "sw", "de", "ca", "xh", "eu", "eo", "hy", "bn", "tg", "sk", "pa", "no", "ga", "fy", "ro", "az", "mi", "gl", "nl", "ms", "el", "su", "sr", "ru", "ny", "ja", "fr", "mk", "kk", "gu", "vi", "bs", "uk", "hr", "ko", "hu", "co", "ht", "tr", "pt", "mn", "cy", "af", "ky", "iw", "da", "ka", "mt", "mr", "sd", "cs", "st", "haw"])
  end
  it "should detect angryness" do
    subject.analyse(ANGRY_TEXT).should eq(true)
  end
  it "should detect whatever" do
    subject.analyse(BPD_TEXT).should eq(true)
  end
  it "should detect sadness" do
    subject.analyse(BPD_TEXTT).should eq(true)
  end
  it "should detect sadness2" do
    subject.analyse(SAD_TEXT).should eq(true)
  end
  it "should detect angry2" do
    subject.analyse(SAD_TEXT).should eq(true)
  end
  it "should detect angry3" do
    subject.analyse(ANGRR).should eq(true)
  end
  it "should return none if gibberish entry" do
    subject.analyse("fsdfgsqgsdheù*merg").should eq(true)
  end
end
