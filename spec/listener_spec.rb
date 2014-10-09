require 'spec_helper'
require 'listener'

import "edu.cmu.sphinx.api.StreamSpeechRecognizer"

DATA_RESOURCES_DIR = "./sphinx4/sphinx4-data/src/main/resources"
ACOUSTIC_MODEL_PATH = File.join(DATA_RESOURCES_DIR, "edu/cmu/sphinx/models/acoustic/wsj")
DICTIONARY_PATH = File.join(DATA_RESOURCES_DIR, "edu/cmu/sphinx/models/acoustic/wsj/dict/cmudict.0.6d")
GRAMMAR_PATH = "./grammars/"

class StreamListener < Listener
  attr_accessor :audio_input_file

  def recognizer
    @recognizer ||= StreamSpeechRecognizer.new(configuration)
  end

  def start_recognition
    recognizer.startRecognition(java.io.FileInputStream.new(audio_input_file))
  end
end

describe Listener do
  let(:listener) do
    StreamListener.new(ACOUSTIC_MODEL_PATH, DICTIONARY_PATH, GRAMMAR_PATH).tap do |listener|
      listener.audio_input_file = audio_input_file
    end
  end

  context "basic navigation commands are spoken" do
    let(:audio_input_file) { "./spec/assets/audio/navigation_commands.wav" }

    it "correctly recognizes the commands" do
      expect(listener).to receive(:handle).with('move up').ordered
      expect(listener).to receive(:handle).with('move left').ordered
      expect(listener).to receive(:handle).with('move down').ordered
      expect(listener).to receive(:handle).with('move right').ordered
      expect(listener).to receive(:handle).with('select').ordered
      expect(listener).to receive(:handle).with('back').ordered
      expect(listener).to receive(:handle).with('exit').ordered

      listener.listen(7)
    end
  end
end
