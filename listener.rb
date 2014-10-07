import "java.util.HashMap"
import "java.util.Map"

$CLASSPATH << "sphinx4/sphinx4-core/target/classes"

import "edu.cmu.sphinx.api.Configuration"
import "edu.cmu.sphinx.api.LiveSpeechRecognizer"

class Listener
  DATA_RESOURCES_DIR = "./sphinx4/sphinx4-data/src/main/resources"
  DEMO_RESOURCES_DIR = "./sphinx4/sphinx4-samples/src/main/resources"
  ACOUSTIC_MODEL = File.join(DATA_RESOURCES_DIR, "edu/cmu/sphinx/models/acoustic/wsj")
  DICTIONARY_PATH = File.join(DATA_RESOURCES_DIR, "edu/cmu/sphinx/models/acoustic/wsj/dict/cmudict.0.6d")
  GRAMMAR_PATH = File.join(DEMO_RESOURCES_DIR, "edu/cmu/sphinx/demo/dialog/")
  LANGUAGE_MODEL = File.join(DEMO_RESOURCES_DIR, "edu/cmu/sphinx/demo/dialog/weather.lm")

  def listen
    configuration = Configuration.new
    configuration.setAcousticModelPath(ACOUSTIC_MODEL)
    configuration.setDictionaryPath(DICTIONARY_PATH)
    configuration.setGrammarPath(GRAMMAR_PATH)
    configuration.setUseGrammar(true)

    configuration.setGrammarName("dialog")
    jsgfRecognizer = LiveSpeechRecognizer.new(configuration)

    configuration.setGrammarName("digits.grxml")
    grxmlRecognizer = LiveSpeechRecognizer.new(configuration)

    configuration.setUseGrammar(false)
    configuration.setLanguageModelPath(LANGUAGE_MODEL)
    lmRecognizer = LiveSpeechRecognizer.new(configuration)

    jsgfRecognizer.startRecognition(true)

    while true do
      puts "Listening..."

      utterance = jsgfRecognizer.getResult().getHypothesis()

      if (utterance.start_with?("exit"))
        break
      end

      if (utterance.end_with?("weather forecast"))
        puts "Weather forecast"
      end
    end
  end
end

Listener.new.listen