require 'xbmc-client'

import "java.util.HashMap"
import "java.util.Map"
import "edu.cmu.sphinx.api.Configuration"
import "edu.cmu.sphinx.api.LiveSpeechRecognizer"

class Listener
  attr_accessor :configuration
  attr_writer :recognizer

  def initialize(acoustic_model_path, dictionary_path, grammar_path)
    self.configuration = Configuration.new

    configuration.setAcousticModelPath(acoustic_model_path)
    configuration.setDictionaryPath(dictionary_path)
    configuration.setGrammarPath(grammar_path)
    configuration.setUseGrammar(true)
    configuration.setGrammarName("xbmc")
  end

  def recognizer
    @recognizer ||= LiveSpeechRecognizer.new(configuration)
  end

  def start_recognition
    recognizer.startRecognition(true)
  end

  def listen(count = Float::INFINITY)
    start_recognition

    say "Listening" if recognizer.is_a?(LiveSpeechRecognizer)

    1.upto(count) do
      puts "Listening..."
      break if handle(recognizer.getResult().getHypothesis()) == false
    end
  end

  def handle(utterance)
    puts utterance

    case
    when utterance.start_with?("exit")
      return false
    when utterance.start_with?('move')
      kodi.input.send utterance.split.last
    when utterance.start_with?('select')
      kodi.input.select
    when utterance.start_with?('back')
      kodi.input.back
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
