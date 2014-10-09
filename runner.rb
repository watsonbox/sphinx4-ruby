$CLASSPATH << "sphinx4/sphinx4-core/target/classes"

require 'listener'

DATA_RESOURCES_DIR = "./sphinx4/sphinx4-data/src/main/resources"
ACOUSTIC_MODEL_PATH = File.join(DATA_RESOURCES_DIR, "edu/cmu/sphinx/models/acoustic/wsj")
DICTIONARY_PATH = File.join(DATA_RESOURCES_DIR, "edu/cmu/sphinx/models/acoustic/wsj/dict/cmudict.0.6d")
GRAMMAR_PATH = "./grammars/"

listener = Listener.new ACOUSTIC_MODEL_PATH, DICTIONARY_PATH, GRAMMAR_PATH

listener.listen