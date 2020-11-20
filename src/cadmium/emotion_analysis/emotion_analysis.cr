require "json"

module Cadmium
  module EmotionAnalysis
    enum Emotion
      Anger
      Anticipation
      Disgust
      Fear
      Joy
      Sadness
      Surprise
      Trust
    end

    # alias LanguageModel = Hash(String, Tuple(Emotion, Float16))
    # # alias ModelsHash = Hash(String, LanguageModel)

    #     struct ModelsHash
    #       property Language_word_emotion_intensity : Hash(String, LanguageModel)

    #       def initialize(data : Hash(String, Tuple(Emotion, Float16)) = Hash(String, Tuple(Emotion, Float16)).new)
    #         @Language_word_emotion_intensity = data
    #       end
    #     end

    struct AllLanguagesModel
      include JSON::Serializable
      property language_word_emotion_score_hash : Hash(String, Hash(String, Tuple(Emotion, Float32)))

      def initialize(hash)
        @language_word_emotion_score_hash = hash
      end
    end

    class Intensity
      include JSON::Serializable
      include Tokenizer
      # include StopWords TODO : rework the whole language symbol / string structure and rework the stopwords macro
      property data : AllLanguagesModel
      # property stop_words
      DEFAULT_MODELS_PATH = "#{__DIR__}/data/all.json"

      def initialize(models_path = DEFAULT_MODELS_PATH)
        json = File.read(DEFAULT_MODELS_PATH)
        @data = AllLanguagesModel.from_json(json)
        # if custom_stop_words.nil?
        # language_word_emotion_score_hash.keys.each
        # end
      end

      def analyse(text : String, language = "en") : Hash(String, Float32)
        # TODO take care of languages !
        bag_of_words = Cadmium::Tokenizer::Aggressive.new.tokenize(text)
        return {"none" => 0.to_f32} if bag_of_words.size < 2
        raw_result = Hash(Emotion, Float32).new
        Emotion.values.each do |emotion|
          raw_result[emotion] = 0.to_f32
        end
        normalizer = 1
        bag_of_words.each do |word|
          if emotion = @data.language_word_emotion_score_hash[language].has_key?(word)
            normalizer += 1
            emotion = @data.language_word_emotion_score_hash[language][word][0]
            score = @data.language_word_emotion_score_hash[language][word][1]
            raw_result[emotion] += score
          end
        end
        raw_result.transform_values! do |score|
          score / normalizer
        end
        result = raw_result.to_a.sort_by { |key, _| key }.to_h.transform_keys { |emotion| emotion.to_s.downcase }
        result
      end
    end
  end
end
