require 'xbmc-client'

import "java.util.HashMap"
import "java.util.Map"

$CLASSPATH << "sphinx4/sphinx4-core/target/classes"

import "edu.cmu.sphinx.api.Configuration"
import "edu.cmu.sphinx.api.LiveSpeechRecognizer"

DATA_RESOURCES_DIR = "./sphinx4/sphinx4-data/src/main/resources"
ACOUSTIC_MODEL_PATH = File.join(DATA_RESOURCES_DIR, "edu/cmu/sphinx/models/acoustic/wsj")
DICTIONARY_PATH = File.join(DATA_RESOURCES_DIR, "edu/cmu/sphinx/models/acoustic/wsj/dict/cmudict.0.6d")
GRAMMAR_PATH = "./grammars/"

class Listener
  attr_accessor :configuration

  def initialize(acoustic_model_path, dictionary_path, grammar_path)
    self.configuration = Configuration.new

    configuration.setAcousticModelPath(acoustic_model_path)
    configuration.setDictionaryPath(dictionary_path)
    configuration.setGrammarPath(grammar_path)
    configuration.setUseGrammar(true)
    configuration.setGrammarName("xbmc")
  end

  def listen
    jsgfRecognizer = LiveSpeechRecognizer.new(configuration).tap do |recognizer|
      recognizer.startRecognition(true)
    end

    say "Listening"

    while true do
      puts "Listening..."

      puts utterance = jsgfRecognizer.getResult().getHypothesis()

      if (utterance.start_with?("exit"))
        break
      elsif (utterance.start_with?('move'))
        kodi.input.send utterance.split.last
      elsif (utterance.start_with?('select'))
        kodi.input.select
      elsif (utterance.start_with?('back'))
        kodi.input.back
      end
    end
  end

  private

  # OSX specific implementation for now
  def say(text)
    `say #{text}`
  end

  # Wrap xbmc-client for nicer API
  def kodi
    return @kodi if @kodi

    Xbmc.base_uri "http://localhost:8080"
    Xbmc.basic_auth "xbmc", "xbmc"
    Xbmc.load_api!

    @kodi = Struct.new(:input).new(Xbmc::Input)
  end
end

listener = Listener.new ACOUSTIC_MODEL_PATH, DICTIONARY_PATH, GRAMMAR_PATH

listener.listen
